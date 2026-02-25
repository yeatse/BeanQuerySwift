import Foundation
import BeancountSwift

/// Output format for rendering query results.
public enum QueryRenderFormat: String, Sendable {
    /// Human-readable aligned table output.
    case text
    /// Comma-separated output with CSV escaping.
    case csv
    /// Beancount source format output (expects directive values).
    case beancount
}

/// Renderer options for text/csv output.
public struct QueryRenderOptions: Sendable {
    /// Whether to render text tables with borders.
    public var boxed: Bool
    /// Whether list/inventory values should expand into multiple output rows.
    public var expand: Bool
    /// Whether text headers should be narrowed to width `1` (beanquery-compatible default).
    public var narrow: Bool
    /// Whether to insert an empty spacer row after each rendered row.
    public var spaced: Bool
    /// Whether to use unicode border/separator characters when available.
    public var unicode: Bool
    /// Separator used for collapsed list/inventory values.
    public var listSeparator: String
    /// Text used to represent null values.
    public var nullValue: String

    /// Creates render options.
    ///
    /// - Parameters:
    ///   - boxed: Whether to render text tables with borders.
    ///   - expand: Whether list/inventory values should expand into multiple output rows.
    ///   - narrow: Whether text headers are narrowed to width `1`.
    ///   - spaced: Whether to insert an empty spacer row after each rendered row.
    ///   - unicode: Whether to use unicode border/separator characters.
    ///   - listSeparator: Separator used for collapsed list/inventory values.
    ///   - nullValue: Text used to represent null values.
    public init(
        boxed: Bool = false,
        expand: Bool = false,
        narrow: Bool = true,
        spaced: Bool = false,
        unicode: Bool = false,
        listSeparator: String = "  ",
        nullValue: String = ""
    ) {
        self.boxed = boxed
        self.expand = expand
        self.narrow = narrow
        self.spaced = spaced
        self.unicode = unicode
        self.listSeparator = listSeparator
        self.nullValue = nullValue
    }
}

/// Rendering errors returned by `QueryRenderer`.
public enum QueryRenderError: LocalizedError, Equatable {
    /// A beancount render row did not contain a directive value.
    case missingBeancountEntry(rowIndex: Int)

    public var errorDescription: String? {
        switch self {
        case .missingBeancountEntry(let rowIndex):
            return "beancount renderer expected a directive value at row \(rowIndex)"
        }
    }
}

/// Renderer utilities for converting `QueryResult` values into textual formats.
public enum QueryRenderer {
    /// Renders a query result into the given format.
    ///
    /// - Parameters:
    ///   - result: Query result to render.
    ///   - format: Output format (`text`, `csv`, or `beancount`).
    ///   - options: Renderer options used by text/csv renderers.
    /// - Returns: Rendered string output.
    /// - Throws: Rendering errors (for example invalid beancount row shape).
    public static func render(
        _ result: QueryResult,
        format: QueryRenderFormat = .text,
        options: QueryRenderOptions = .init()
    ) throws -> String {
        switch format {
        case .text:
            return renderText(result, options: options)
        case .csv:
            return renderCSV(result, options: options)
        case .beancount:
            return try renderBeancount(result)
        }
    }
}

public extension QueryResult {
    /// Renders this query result into the given format.
    ///
    /// - Parameters:
    ///   - format: Output format (`text`, `csv`, or `beancount`).
    ///   - options: Renderer options used by text/csv renderers.
    /// - Returns: Rendered string output.
    /// - Throws: Rendering errors (for example invalid beancount row shape).
    func render(
        as format: QueryRenderFormat = .text,
        options: QueryRenderOptions = .init()
    ) throws -> String {
        try QueryRenderer.render(self, format: format, options: options)
    }
}

private enum QueryRendererImpl {
    enum Alignment {
        case left
        case right
    }

    enum CellValue {
        case single(String)
        case multi([String])
    }

    struct RenderContext {
        var expand: Bool
        var listSeparator: String
        var nullValue: String
        var spaced: Bool
    }

    enum ValueKind: Hashable {
        case object
        case string
        case bool
        case date
        case int
        case decimal
        case amount
        case position
        case inventory
        case list
        case directive
    }

    class ColumnRenderer {
        var maxWidth = 0
        let align: Alignment
        let context: RenderContext

        init(align: Alignment = .left, context: RenderContext) {
            self.align = align
            self.context = context
        }

        func update(_ value: RuntimeValue) {}

        func prepare() -> Int {
            maxWidth
        }

        func format(_ value: RuntimeValue) -> CellValue {
            .single("")
        }
    }

    final class ObjectRenderer: ColumnRenderer {
        override func update(_ value: RuntimeValue) {
            maxWidth = max(maxWidth, stringify(value).count)
        }

        override func format(_ value: RuntimeValue) -> CellValue {
            .single(stringify(value))
        }
    }

    final class StringRenderer: ColumnRenderer {
        override func update(_ value: RuntimeValue) {
            guard case .string(let text) = value else { return }
            maxWidth = max(maxWidth, text.count)
        }

        override func format(_ value: RuntimeValue) -> CellValue {
            guard case .string(let text) = value else { return .single("") }
            return .single(text)
        }
    }

    final class BoolRenderer: ColumnRenderer {
        override func update(_ value: RuntimeValue) {
            guard case .bool(let bool) = value else { return }
            maxWidth = max(maxWidth, bool ? 4 : 5)
        }

        override func format(_ value: RuntimeValue) -> CellValue {
            guard case .bool(let bool) = value else { return .single("") }
            return .single(bool ? "TRUE" : "FALSE")
        }
    }

    final class DateRenderer: ColumnRenderer {
        override func update(_ value: RuntimeValue) {
            guard case .date = value else { return }
            maxWidth = max(maxWidth, 10)
        }

        override func format(_ value: RuntimeValue) -> CellValue {
            guard case .date(let date) = value else { return .single("") }
            return .single(formatDate(date))
        }
    }

    final class IntRenderer: ColumnRenderer {
        init(context: RenderContext) {
            super.init(align: .right, context: context)
        }

        override func update(_ value: RuntimeValue) {
            guard case .int(let number) = value else { return }
            maxWidth = max(maxWidth, String(number).count)
        }

        override func format(_ value: RuntimeValue) -> CellValue {
            guard case .int(let number) = value else { return .single("") }
            return .single(String(number))
        }
    }

    final class DecimalRenderer: ColumnRenderer {
        var nintegral = 0
        var nfractional = 0

        init(context: RenderContext) {
            super.init(align: .right, context: context)
        }

        override func update(_ value: RuntimeValue) {
            let decimal: Decimal
            switch value {
            case .decimal(let raw):
                decimal = raw
            case .int(let raw):
                decimal = Decimal(raw)
            default:
                return
            }

            let rendered = renderDecimal(decimal)
            if rendered.contains("E") || rendered.contains("e") {
                nintegral = max(nintegral, rendered.count)
                return
            }

            if let dot = rendered.firstIndex(of: ".") {
                let integral = rendered[..<dot]
                let fractional = rendered[rendered.index(after: dot)...]
                nintegral = max(nintegral, max(1, integral.count))
                nfractional = max(nfractional, fractional.count)
            } else {
                nintegral = max(nintegral, max(1, rendered.count))
            }
        }

        override func prepare() -> Int {
            maxWidth = nintegral + nfractional + (nfractional > 0 ? 1 : 0)
            return super.prepare()
        }

        override func format(_ value: RuntimeValue) -> CellValue {
            let decimal: Decimal
            switch value {
            case .decimal(let raw):
                decimal = raw
            case .int(let raw):
                decimal = Decimal(raw)
            default:
                return .single("")
            }

            let rendered = renderDecimal(decimal)
            if rendered.contains("E") || rendered.contains("e") {
                return .single(ljust(rjust(rendered, nintegral), maxWidth))
            }

            let integralLength: Int
            if let dot = rendered.firstIndex(of: ".") {
                integralLength = rendered[..<dot].count
            } else {
                integralLength = rendered.count
            }
            let leftPadding = max(0, nintegral - max(1, integralLength))
            let prefixed = String(repeating: " ", count: leftPadding) + rendered
            return .single(ljust(prefixed, maxWidth))
        }

        private func renderDecimal(_ value: Decimal) -> String {
            NSDecimalNumber(decimal: value).stringValue
        }
    }

    final class AmountRenderer: ColumnRenderer {
        override func update(_ value: RuntimeValue) {
            guard case .amount(let amount) = value else { return }
            maxWidth = max(maxWidth, amount.description.count)
        }

        override func format(_ value: RuntimeValue) -> CellValue {
            guard case .amount(let amount) = value else { return .single("") }
            return .single(amount.description)
        }
    }

    final class PositionRenderer: ColumnRenderer {
        override func update(_ value: RuntimeValue) {
            guard case .position(let position) = value else { return }
            maxWidth = max(maxWidth, position.description.count)
        }

        override func format(_ value: RuntimeValue) -> CellValue {
            guard case .position(let position) = value else { return .single("") }
            return .single(position.description)
        }
    }

    final class InventoryRenderer: ColumnRenderer {
        override func update(_ value: RuntimeValue) {
            guard case .inventory(let inventory) = value else { return }
            let lines = inventoryLines(inventory, expand: context.expand, separator: context.listSeparator)
            switch lines {
            case .single(let rendered):
                maxWidth = max(maxWidth, rendered.count)
            case .multi(let rendered):
                let width = rendered.map(\.count).max() ?? 0
                maxWidth = max(maxWidth, width)
            }
        }

        override func format(_ value: RuntimeValue) -> CellValue {
            guard case .inventory(let inventory) = value else { return .single("") }
            return inventoryLines(inventory, expand: context.expand, separator: context.listSeparator)
        }
    }

    final class ListRenderer: ColumnRenderer {
        override func update(_ value: RuntimeValue) {
            guard case .list(let values) = value else { return }
            if context.expand {
                let width = values.map { stringify($0).count }.max() ?? 0
                maxWidth = max(maxWidth, width)
            } else {
                let rendered = values.map(stringify).joined(separator: context.listSeparator)
                maxWidth = max(maxWidth, rendered.count)
            }
        }

        override func format(_ value: RuntimeValue) -> CellValue {
            guard case .list(let values) = value else { return .single("") }
            if context.expand {
                if values.isEmpty {
                    return .single("")
                }
                return .multi(values.map(stringify))
            }
            return .single(values.map(stringify).joined(separator: context.listSeparator))
        }
    }

    final class DirectiveRenderer: ColumnRenderer {
        override func update(_ value: RuntimeValue) {
            guard case .directive(let directive) = value else { return }
            maxWidth = max(maxWidth, directive.description.trimmingCharacters(in: .newlines).count)
        }

        override func format(_ value: RuntimeValue) -> CellValue {
            guard case .directive(let directive) = value else { return .single("") }
            return .single(directive.description.trimmingCharacters(in: .newlines))
        }
    }

    static func renderText(_ result: QueryResult, options: QueryRenderOptions) -> String {
        // Align with Python beanquery.render.text: emit nothing for empty results.
        if result.rows.isEmpty {
            return ""
        }

        let context = RenderContext(
            expand: options.expand,
            listSeparator: options.listSeparator,
            nullValue: options.nullValue,
            spaced: options.spaced
        )
        let renderers = buildRenderers(result: result, context: context)
        let headers = result.columns
        let widths = zip(headers, renderers).map { header, renderer in
            let headerBase = options.narrow ? 1 : header.count
            return max(1, headerBase, options.nullValue.count, renderer.prepare())
        }

        let style = makeTextStyle(widths: widths, boxed: options.boxed, unicode: options.unicode)
        var output = ""

        output += style.top
        let headerCells = zip(headers, widths).map { header, width in
            center(String(header.prefix(width)), width)
        }
        output += style.formatRow(headerCells)
        output += style.hline

        for row in renderRows(rows: result.rows, renderers: renderers, context: context) {
            let cells = zip(zip(row, widths), renderers).map { pair, renderer in
                let (value, width) = pair
                switch renderer.align {
                case .left:
                    return ljust(value, width)
                case .right:
                    return rjust(value, width)
                }
            }
            output += style.formatRow(cells)
        }

        output += style.bottom
        return output
    }

    static func renderCSV(_ result: QueryResult, options: QueryRenderOptions) -> String {
        let context = RenderContext(
            expand: options.expand,
            listSeparator: ",",
            nullValue: options.nullValue,
            spaced: false
        )
        let renderers = buildRenderers(result: result, context: context)
        _ = renderers.map { $0.prepare() }

        var output = ""
        output += encodeCSVRow(result.columns) + "\n"
        for row in renderRows(rows: result.rows, renderers: renderers, context: context) {
            output += encodeCSVRow(row) + "\n"
        }
        return output
    }

    static func renderBeancount(_ result: QueryResult) throws -> String {
        if result.rows.isEmpty {
            return ""
        }

        let entryIndex = result.columns.firstIndex(of: "entry")
        var rendered = ""

        for (rowIndex, row) in result.rows.enumerated() {
            let directive = extractDirective(row: row, preferredIndex: entryIndex)
            guard let directive else {
                throw QueryRenderError.missingBeancountEntry(rowIndex: rowIndex)
            }
            if directive.description.hasSuffix("\n") {
                rendered += directive.description
            } else {
                rendered += directive.description + "\n"
            }
        }

        return rendered
    }

    private static func buildRenderers(result: QueryResult, context: RenderContext) -> [ColumnRenderer] {
        result.columns.indices.map { index in
            let values = result.rows.map { row in
                guard index < row.count else { return RuntimeValue.null }
                return row[index]
            }
            let kind = inferKind(values)
            let renderer = makeRenderer(kind: kind, context: context)
            for value in values where value != .null {
                renderer.update(value)
            }
            return renderer
        }
    }

    private static func inferKind(_ values: [RuntimeValue]) -> ValueKind {
        let kinds = Set(values.compactMap { value -> ValueKind? in
            guard value != .null else { return nil }
            return valueKind(value)
        })

        if kinds.isEmpty {
            return .object
        }
        if kinds == [.int] {
            return .int
        }
        if kinds == [.decimal] || kinds == [.int, .decimal] {
            return .decimal
        }
        if kinds.count == 1 {
            return kinds.first ?? .object
        }
        return .object
    }

    private static func valueKind(_ value: RuntimeValue) -> ValueKind {
        switch value {
        case .int:
            return .int
        case .decimal:
            return .decimal
        case .amount:
            return .amount
        case .position:
            return .position
        case .inventory:
            return .inventory
        case .directive:
            return .directive
        case .dict:
            return .object
        case .string:
            return .string
        case .bool:
            return .bool
        case .date:
            return .date
        case .list:
            return .list
        case .null:
            return .object
        }
    }

    private static func makeRenderer(kind: ValueKind, context: RenderContext) -> ColumnRenderer {
        switch kind {
        case .string:
            return StringRenderer(context: context)
        case .bool:
            return BoolRenderer(context: context)
        case .date:
            return DateRenderer(context: context)
        case .int:
            return IntRenderer(context: context)
        case .decimal:
            return DecimalRenderer(context: context)
        case .amount:
            return AmountRenderer(context: context)
        case .position:
            return PositionRenderer(context: context)
        case .inventory:
            return InventoryRenderer(context: context)
        case .list:
            return ListRenderer(context: context)
        case .directive:
            return DirectiveRenderer(context: context)
        case .object:
            return ObjectRenderer(context: context)
        }
    }

    private static func renderRows(
        rows: [[RuntimeValue]],
        renderers: [ColumnRenderer],
        context: RenderContext
    ) -> [[String]] {
        let spacer = Array(repeating: "", count: renderers.count)
        var renderedRows: [[String]] = []

        for row in rows {
            let cells: [CellValue] = renderers.enumerated().map { index, renderer in
                let value: RuntimeValue
                if index < row.count {
                    value = row[index]
                } else {
                    value = .null
                }
                if value == .null {
                    return .single(context.nullValue)
                }
                return renderer.format(value)
            }

            if !cells.contains(where: {
                if case .multi = $0 { return true }
                return false
            }) {
                renderedRows.append(
                    cells.map { cell in
                        if case .single(let text) = cell {
                            return text
                        }
                        return ""
                    }
                )
            } else {
                var lines: [[String]] = cells.map { cell in
                    switch cell {
                    case .single(let text):
                        return [text]
                    case .multi(let values):
                        return values
                    }
                }

                let maxLines = lines.map(\.count).max() ?? 0
                for index in lines.indices where lines[index].count < maxLines {
                    lines[index].append(
                        contentsOf: Array(
                            repeating: "",
                            count: maxLines - lines[index].count
                        )
                    )
                }

                for lineIndex in 0..<maxLines {
                    renderedRows.append(lines.map { $0[lineIndex] })
                }
            }

            if context.spaced {
                renderedRows.append(spacer)
            }
        }

        return renderedRows
    }

    private static func stringify(_ value: RuntimeValue) -> String {
        switch value {
        case .int(let number):
            return String(number)
        case .decimal(let number):
            return NSDecimalNumber(decimal: number).stringValue
        case .amount(let amount):
            return amount.description
        case .position(let position):
            return position.description
        case .inventory(let inventory):
            return inventory.description
        case .directive(let directive):
            return directive.description.trimmingCharacters(in: .newlines)
        case .dict(let dictionary):
            let parts = dictionary.keys.sorted().map { key -> String in
                "\(key):\(stringify(dictionary[key] ?? .null))"
            }
            return "{\(parts.joined(separator: ","))}"
        case .string(let text):
            return text
        case .bool(let value):
            return value ? "TRUE" : "FALSE"
        case .date(let date):
            return formatDate(date)
        case .list(let values):
            return values.map(stringify).joined(separator: ", ")
        case .null:
            return ""
        }
    }

    private static func inventoryLines(
        _ inventory: Inventory,
        expand: Bool,
        separator: String
    ) -> CellValue {
        let positions = splitInventoryDescription(inventory.description)

        if expand {
            if positions.isEmpty {
                return .single("")
            }
            return .multi(positions)
        }

        let rendered = positions.joined(separator: separator)
        return .single(rendered)
    }

    private static func formatDate(_ date: Date) -> String {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone.current
        let parts = calendar.dateComponents([.year, .month, .day], from: date)
        let year = parts.year ?? 0
        let month = parts.month ?? 0
        let day = parts.day ?? 0
        return String(format: "%04d-%02d-%02d", year, month, day)
    }

    private static func splitInventoryDescription(_ value: String) -> [String] {
        var parts: [String] = []
        var current = ""
        var braceDepth = 0
        var inQuotes = false

        var index = value.startIndex
        while index < value.endIndex {
            let char = value[index]

            if char == "\"" {
                inQuotes.toggle()
                current.append(char)
                index = value.index(after: index)
                continue
            }

            if !inQuotes {
                if char == "{" {
                    braceDepth += 1
                    current.append(char)
                    index = value.index(after: index)
                    continue
                }
                if char == "}" {
                    braceDepth = max(0, braceDepth - 1)
                    current.append(char)
                    index = value.index(after: index)
                    continue
                }

                if char == ",", braceDepth == 0 {
                    let trimmed = current.trimmingCharacters(in: .whitespaces)
                    if !trimmed.isEmpty {
                        parts.append(trimmed)
                    }
                    current.removeAll(keepingCapacity: true)
                    index = value.index(after: index)
                    while index < value.endIndex, value[index] == " " {
                        index = value.index(after: index)
                    }
                    continue
                }
            }

            current.append(char)
            index = value.index(after: index)
        }

        let trailing = current.trimmingCharacters(in: .whitespaces)
        if !trailing.isEmpty {
            parts.append(trailing)
        }
        return parts
    }

    private static func extractDirective(
        row: [RuntimeValue],
        preferredIndex: Int?
    ) -> Directive<Cost>? {
        if let preferredIndex,
           preferredIndex < row.count,
           case .directive(let directive) = row[preferredIndex] {
            return directive
        }

        for value in row {
            if case .directive(let directive) = value {
                return directive
            }
        }
        return nil
    }

    private static func encodeCSVRow(_ values: [String]) -> String {
        values.map(escapeCSVField).joined(separator: ",")
    }

    private static func escapeCSVField(_ field: String) -> String {
        let needsQuoting = field.contains(",") || field.contains("\"") || field.contains("\n") || field.contains("\r")
        if !needsQuoting {
            return field
        }
        return "\"" + field.replacingOccurrences(of: "\"", with: "\"\"") + "\""
    }

    private struct TextStyle {
        var top: String
        var hline: String
        var bottom: String
        var formatRow: ([String]) -> String
    }

    private static func makeTextStyle(widths: [Int], boxed: Bool, unicode: Bool) -> TextStyle {
        if boxed {
            if unicode {
                let lines = widths.map { String(repeating: "─", count: $0) }
                let top = "┌─" + lines.joined(separator: "─┬─") + "─┐\n"
                let hline = "├─" + lines.joined(separator: "─┼─") + "─┤\n"
                let bottom = "└─" + lines.joined(separator: "─┴─") + "─┘\n"
                return TextStyle(
                    top: top,
                    hline: hline,
                    bottom: bottom,
                    formatRow: { cells in "│ " + cells.joined(separator: " │ ") + " │\n" }
                )
            }

            let lines = widths.map { String(repeating: "-", count: $0) }
            let border = "+-" + lines.joined(separator: "-+-") + "-+\n"
            return TextStyle(
                top: border,
                hline: border,
                bottom: border,
                formatRow: { cells in "| " + cells.joined(separator: " | ") + " |\n" }
            )
        }

        let separator = "  "
        let lineChar = unicode ? "─" : "-"
        let hline = widths.map { String(repeating: lineChar, count: $0) }.joined(separator: separator) + "\n"
        return TextStyle(
            top: "",
            hline: hline,
            bottom: "",
            formatRow: { cells in cells.joined(separator: separator) + "\n" }
        )
    }

    private static func ljust(_ value: String, _ width: Int) -> String {
        if value.count >= width { return value }
        return value + String(repeating: " ", count: width - value.count)
    }

    private static func rjust(_ value: String, _ width: Int) -> String {
        if value.count >= width { return value }
        return String(repeating: " ", count: width - value.count) + value
    }

    private static func center(_ value: String, _ width: Int) -> String {
        if value.count >= width { return String(value.prefix(width)) }
        let left = (width - value.count) / 2
        let right = width - value.count - left
        return String(repeating: " ", count: left) + value + String(repeating: " ", count: right)
    }
}

private func renderText(_ result: QueryResult, options: QueryRenderOptions) -> String {
    QueryRendererImpl.renderText(result, options: options)
}

private func renderCSV(_ result: QueryResult, options: QueryRenderOptions) -> String {
    QueryRendererImpl.renderCSV(result, options: options)
}

private func renderBeancount(_ result: QueryResult) throws -> String {
    try QueryRendererImpl.renderBeancount(result)
}
