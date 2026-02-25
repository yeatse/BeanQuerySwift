import Foundation
import BeancountSwift

struct BuiltinFunctionEvaluator {
    private struct DateStride: Equatable, Sendable {
        var years: Int
        var months: Int
        var days: Int

        var hasMonthOrYearComponent: Bool {
            years != 0 || months != 0
        }

        var dayStride: Int? {
            hasMonthOrYearComponent ? nil : days
        }

        var negated: DateStride {
            DateStride(years: -years, months: -months, days: -days)
        }

        var runtimeValue: RuntimeValue {
            .list([.int(years), .int(months), .int(days)])
        }

        static func fromRuntimeValue(_ value: RuntimeValue) -> DateStride? {
            guard case .list(let values) = value,
                  values.count == 3,
                  case .int(let years) = values[0],
                  case .int(let months) = values[1],
                  case .int(let days) = values[2]
            else {
                return nil
            }

            return DateStride(years: years, months: months, days: days)
        }
    }

    private let context: QueryContext

    init(context: QueryContext) {
        self.context = context
    }

    func evaluate(
        name: String,
        normalizedName: String,
        arguments values: [RuntimeValue],
        row: QueryRow?
    ) throws -> RuntimeValue {
        switch normalizedName {
        case "abs":
            guard values.count == 1 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            return try absolute(values[0])

        // Type casting
        case "bool":
            guard values.count == 1 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            return castToBool(values[0])

        case "int":
            guard values.count == 1 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            return castToInt(values[0])

        case "decimal":
            guard values.count == 1 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            return castToDecimal(values[0])

        case "str":
            guard values.count == 1 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            return castToString(values[0])

        // Functions
        case "maxwidth":
            guard values.count == 2 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }

            guard case .string(let text) = values[0], let width = asInt(values[1]) else {
                if values[0] == .null {
                    return .null
                }
                throw BQLExecutionError.invalidType
            }
            return .string(String(text.prefix(max(width, 0))))

        // Operations on dates
        case "date":
            if values.count == 1 {
                switch values[0] {
                case .date(let date):
                    return .date(date)
                case .string(let string):
                    return parseDateExactYMD(string).map(RuntimeValue.date) ?? .null
                case .null:
                    return .null
                default:
                    return .null
                }
            }

            guard values.count == 3 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            if values.contains(.null) {
                return .null
            }
            guard let year = asInt(values[0]),
                  let month = asInt(values[1]),
                  let day = asInt(values[2])
            else {
                throw BQLExecutionError.invalidType
            }
            return buildDate(year: year, month: month, day: day).map(RuntimeValue.date) ?? .null

        case "year":
            guard values.count == 1 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            if values[0] == .null {
                return .null
            }
            guard case .date(let date) = values[0] else {
                throw BQLExecutionError.invalidType
            }
            return .int(dateParts(date).year)

        case "month":
            guard values.count == 1 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            if values[0] == .null {
                return .null
            }
            guard case .date(let date) = values[0] else {
                throw BQLExecutionError.invalidType
            }
            return .int(dateParts(date).month)

        case "day":
            guard values.count == 1 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            if values[0] == .null {
                return .null
            }
            guard case .date(let date) = values[0] else {
                throw BQLExecutionError.invalidType
            }
            return .int(dateParts(date).day)

        case "yearmonth":
            guard values.count == 1 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            if values[0] == .null {
                return .null
            }
            guard case .date(let date) = values[0] else {
                throw BQLExecutionError.invalidType
            }
            let parts = dateParts(date)
            return buildDate(year: parts.year, month: parts.month, day: 1).map(RuntimeValue.date) ?? .null

        case "quarter":
            guard values.count == 1 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            if values[0] == .null {
                return .null
            }
            guard case .date(let date) = values[0] else {
                throw BQLExecutionError.invalidType
            }
            let parts = dateParts(date)
            let quarter = (parts.month - 1) / 3 + 1
            return .string(String(format: "%04d-Q%d", parts.year, quarter))

        case "weekday":
            guard values.count == 1 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            if values[0] == .null {
                return .null
            }
            guard case .date(let date) = values[0] else {
                throw BQLExecutionError.invalidType
            }
            return .string(weekdayAbbreviation(for: date))

        case "today":
            guard values.isEmpty else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            return .date(today())

        case "parse_date":
            guard values.count == 1 || values.count == 2 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            if values.contains(.null) {
                return .null
            }
            guard case .string(let input) = values[0] else {
                throw BQLExecutionError.invalidType
            }
            if values.count == 2 {
                guard case .string(let format) = values[1] else {
                    throw BQLExecutionError.invalidType
                }
                return parseDate(input, withPythonFormat: format).map(RuntimeValue.date) ?? .null
            }
            return parseDate(input).map(RuntimeValue.date) ?? .null

        case "date_diff":
            guard values.count == 2 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            if values.contains(.null) {
                return .null
            }
            guard case .date(let x) = values[0], case .date(let y) = values[1] else {
                throw BQLExecutionError.invalidType
            }
            guard let diff = daysBetween(y, x) else {
                return .null
            }
            return .int(diff)

        case "date_add":
            guard values.count == 2 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            if values.contains(.null) {
                return .null
            }
            guard case .date(let date) = values[0],
                  let offset = asInt(values[1])
            else {
                throw BQLExecutionError.invalidType
            }
            return addDays(date, offset).map(RuntimeValue.date) ?? .null

        case "date_trunc":
            guard values.count == 2 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            if values.contains(.null) {
                return .null
            }
            guard case .string(let field) = values[0], case .date(let date) = values[1] else {
                throw BQLExecutionError.invalidType
            }
            return dateTrunc(field: field, date: date).map(RuntimeValue.date) ?? .null

        case "date_part":
            guard values.count == 2 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            if values.contains(.null) {
                return .null
            }
            guard case .string(let field) = values[0], case .date(let date) = values[1] else {
                throw BQLExecutionError.invalidType
            }
            return datePart(field: field, date: date).map(RuntimeValue.int) ?? .null

        case "interval":
            guard values.count == 1 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            if values[0] == .null {
                return .null
            }
            guard case .string(let stride) = values[0] else {
                throw BQLExecutionError.invalidType
            }
            return parseInterval(stride)?.runtimeValue ?? .null

        case "date_bin":
            guard values.count == 3 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            if values.contains(.null) {
                return .null
            }
            let stride: DateStride?
            if let parsed = DateStride.fromRuntimeValue(values[0]) {
                stride = parsed
            } else if case .string(let strideString) = values[0] {
                stride = parseInterval(strideString)
            } else {
                throw BQLExecutionError.invalidType
            }
            guard let stride else {
                return .null
            }
            guard case .date(let source) = values[1], case .date(let origin) = values[2] else {
                throw BQLExecutionError.invalidType
            }
            return dateBin(stride: stride, source: source, origin: origin).map(RuntimeValue.date) ?? .null

        // Operations on accounts
        case "root":
            guard values.count == 1 || values.count == 2 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            if values[0] == .null {
                return .null
            }
            guard case .string(let account) = values[0] else {
                throw BQLExecutionError.invalidType
            }

            let componentCount: Int
            if values.count == 2 {
                if values[1] == .null {
                    return .null
                }
                guard let count = asInt(values[1]) else {
                    throw BQLExecutionError.invalidType
                }
                componentCount = count
            } else {
                componentCount = 1
            }
            return .string(accountRoot(account, components: componentCount))

        case "parent":
            guard values.count == 1 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            if values[0] == .null {
                return .null
            }
            guard case .string(let account) = values[0] else {
                throw BQLExecutionError.invalidType
            }
            return parentAccount(account).map(RuntimeValue.string) ?? .null

        case "leaf":
            guard values.count == 1 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            if values[0] == .null {
                return .null
            }
            guard case .string(let account) = values[0] else {
                throw BQLExecutionError.invalidType
            }
            return leafAccount(account).map(RuntimeValue.string) ?? .null

        case "grep":
            guard values.count == 2 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            if values.contains(.null) {
                return .null
            }
            guard case .string(let pattern) = values[0],
                  case .string(let string) = values[1]
            else {
                throw BQLExecutionError.invalidType
            }
            return firstRegexMatch(pattern: pattern, in: string).map(RuntimeValue.string) ?? .null

        case "grepn":
            guard values.count == 3 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            if values.contains(.null) {
                return .null
            }
            guard case .string(let pattern) = values[0],
                  case .string(let string) = values[1],
                  let groupIndex = asInt(values[2])
            else {
                throw BQLExecutionError.invalidType
            }
            return regexGroup(pattern: pattern, in: string, index: groupIndex).map(RuntimeValue.string) ?? .null

        case "subst":
            guard values.count == 3 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            if values.contains(.null) {
                return .null
            }
            guard case .string(let pattern) = values[0],
                  case .string(let replacement) = values[1],
                  case .string(let string) = values[2]
            else {
                throw BQLExecutionError.invalidType
            }
            return substituteRegex(pattern: pattern, replacement: replacement, in: string).map(RuntimeValue.string) ?? .null

        case "upper":
            guard values.count == 1 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            if values[0] == .null {
                return .null
            }
            guard case .string(let string) = values[0] else {
                throw BQLExecutionError.invalidType
            }
            return .string(string.uppercased())

        case "lower":
            guard values.count == 1 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            if values[0] == .null {
                return .null
            }
            guard case .string(let string) = values[0] else {
                throw BQLExecutionError.invalidType
            }
            return .string(string.lowercased())

        case "open_date":
            guard values.count == 1 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            if values[0] == .null {
                return .null
            }
            guard case .string(let account) = values[0] else {
                throw BQLExecutionError.invalidType
            }
            return lookupAccount(account)?["open_date"] ?? .null

        case "close_date":
            guard values.count == 1 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            if values[0] == .null {
                return .null
            }
            guard case .string(let account) = values[0] else {
                throw BQLExecutionError.invalidType
            }
            return lookupAccount(account)?["close_date"] ?? .null

        case "open_meta":
            guard values.count == 1 || values.count == 2 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            if values[0] == .null {
                return .null
            }
            guard case .string(let account) = values[0] else {
                throw BQLExecutionError.invalidType
            }

            guard let accountRow = lookupAccount(account),
                  case .dict(let metadata) = accountRow["open_meta"] ?? .null
            else {
                return .null
            }

            if values.count == 1 {
                return .dict(metadata)
            }
            if values[1] == .null {
                return .null
            }
            guard case .string(let key) = values[1] else {
                throw BQLExecutionError.invalidType
            }
            return metadata[key] ?? .null

        case "account_sortkey":
            guard values.count == 1 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            if values[0] == .null {
                return .null
            }
            guard case .string(let account) = values[0] else {
                throw BQLExecutionError.invalidType
            }
            let index = accountSortIndex(account)
            return .string("\(index)-\(account)")

        case "has_account":
            guard values.count == 1 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            if values[0] == .null {
                return .null
            }
            guard case .string(let pattern) = values[0] else {
                throw BQLExecutionError.invalidType
            }
            return .bool(rowHasAccount(row: row, pattern: pattern))

        // Operation on inventories, positions and amounts
        case "units":
            guard values.count == 1 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            return try units(values[0])

        case "cost":
            guard values.count == 1 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            return try cost(values[0])

        case "weight":
            guard values.count == 1 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            return try weight(values[0])

        case "convert":
            guard values.count == 2 || values.count == 3 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            guard case .string(let targetCurrency) = values[1] else {
                throw BQLExecutionError.invalidType
            }

            let date: Date?
            if values.count == 3 {
                guard case .date(let suppliedDate) = values[2] else {
                    throw BQLExecutionError.invalidType
                }
                date = suppliedDate
            } else {
                date = nil
            }
            return try convert(values[0], targetCurrency: targetCurrency, date: date)

        case "value":
            guard values.count == 1 || values.count == 2 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            let date: Date?
            if values.count == 2 {
                guard case .date(let suppliedDate) = values[1] else {
                    throw BQLExecutionError.invalidType
                }
                date = suppliedDate
            } else {
                date = nil
            }
            return try value(values[0], date: date)

        case "getprice":
            guard values.count == 2 || values.count == 3 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            guard case .string(let baseCurrency) = values[0],
                  case .string(let quoteCurrency) = values[1]
            else {
                throw BQLExecutionError.invalidType
            }

            let date: Date?
            if values.count == 3 {
                guard case .date(let suppliedDate) = values[2] else {
                    throw BQLExecutionError.invalidType
                }
                date = suppliedDate
            } else {
                date = nil
            }
            return getprice(base: baseCurrency, quote: quoteCurrency, date: date)

        case "number":
            guard values.count == 1 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            return try number(values[0])

        case "currency", "commodity":
            guard values.count == 1 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            return try currency(values[0])

        case "findfirst":
            guard values.count == 2 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            if values.contains(.null) {
                return .null
            }
            guard case .string(let pattern) = values[0],
                  let stringValues = asStringList(values[1])
            else {
                throw BQLExecutionError.invalidType
            }
            return findFirst(pattern: pattern, in: stringValues).map(RuntimeValue.string) ?? .null

        case "joinstr":
            guard values.count == 1 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            if values[0] == .null {
                return .null
            }
            guard let stringValues = asStringList(values[0]) else {
                throw BQLExecutionError.invalidType
            }
            return .string(stringValues.joined(separator: ","))

        case "only":
            guard values.count == 2 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            guard case .string(let currency) = values[0] else {
                throw BQLExecutionError.invalidType
            }
            return try only(currency: currency, inventory: values[1])

        case "empty":
            guard values.count == 1 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            return try empty(values[0])

        case "filter_currency":
            guard values.count == 2 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            guard case .string(let currency) = values[1] else {
                throw BQLExecutionError.invalidType
            }
            return try filterCurrency(values[0], currency: currency)

        case "possign":
            guard values.count == 2 else {
                throw BQLExecutionError.unsupportedFunction(name)
            }
            guard case .string(let account) = values[1] else {
                throw BQLExecutionError.invalidType
            }
            return try possign(values[0], account: account)

        default:
            throw BQLExecutionError.unsupportedFunction(name)
        }
    }

    private func absolute(_ value: RuntimeValue) throws -> RuntimeValue {
        switch value {
        case .int(let int):
            return .int(Swift.abs(int))
        case .decimal(let decimal):
            return .decimal(Swift.abs(decimal))
        case .amount(let amount):
            return .amount(amount.absolute)
        case .position(let position):
            return .position(position.units.number < .zero ? -position : position)
        case .inventory(let inventory):
            return .inventory(inventory.absolute)
        case .null:
            return .null
        default:
            throw BQLExecutionError.invalidType
        }
    }

    private func castToBool(_ value: RuntimeValue) -> RuntimeValue {
        switch value {
        case .null:
            return .null
        case .bool(let bool):
            return .bool(bool)
        case .int(let int):
            return .bool(int != 0)
        case .decimal(let decimal):
            return .bool(decimal != .zero)
        case .string(let string):
            return .bool(!string.isEmpty)
        case .list(let values):
            return .bool(!values.isEmpty)
        case .inventory(let inventory):
            return .bool(!inventory.isEmpty)
        default:
            return .bool(true)
        }
    }

    private func castToInt(_ value: RuntimeValue) -> RuntimeValue {
        switch value {
        case .null:
            return .null
        case .int(let int):
            return .int(int)
        case .bool(let bool):
            return .int(bool ? 1 : 0)
        case .decimal(let decimal):
            return .int(NSDecimalNumber(decimal: decimal).intValue)
        case .string(let string):
            let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
            return Int(trimmed).map(RuntimeValue.int) ?? .null
        default:
            return .null
        }
    }

    private func castToDecimal(_ value: RuntimeValue) -> RuntimeValue {
        switch value {
        case .null:
            return .null
        case .decimal(let decimal):
            return .decimal(decimal)
        case .int(let int):
            return .decimal(Decimal(int))
        case .bool(let bool):
            return .decimal(bool ? Decimal(1) : .zero)
        case .string(let string):
            let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
            return Decimal(string: trimmed, locale: Locale(identifier: "en_US_POSIX"))
                .map(RuntimeValue.decimal) ?? .null
        default:
            return .null
        }
    }

    private func castToString(_ value: RuntimeValue) -> RuntimeValue {
        switch value {
        case .null:
            return .null
        case .bool(let bool):
            return .string(bool ? "TRUE" : "FALSE")
        case .int(let int):
            return .string(String(int))
        case .decimal(let decimal):
            return .string(NSDecimalNumber(decimal: decimal).stringValue)
        case .amount(let amount):
            return .string(amount.description)
        case .position(let position):
            return .string(position.description)
        case .inventory(let inventory):
            return .string(inventory.description)
        case .directive(let directive):
            return .string(directive.description.trimmingCharacters(in: .newlines))
        case .dict(let dictionary):
            let keys = dictionary.keys.sorted()
            let rendered = keys.map { key in
                let renderedValue = castToString(dictionary[key] ?? .null)
                guard case .string(let stringValue) = renderedValue else {
                    return "\(key):"
                }
                return "\(key):\(stringValue)"
            }
            return .string("{\(rendered.joined(separator: ","))}")
        case .string(let string):
            return .string(string)
        case .date(let date):
            let parts = dateParts(date)
            return .string(String(format: "%04d-%02d-%02d", parts.year, parts.month, parts.day))
        case .list(let values):
            let rendered = values.map { value in
                let cast = castToString(value)
                if case .string(let string) = cast {
                    return string
                }
                return "NULL"
            }
            return .string(rendered.joined(separator: ","))
        }
    }

    private func units(_ value: RuntimeValue) throws -> RuntimeValue {
        switch value {
        case .int, .decimal, .amount:
            return value
        case .position(let position):
            return .amount(position.units)
        case .inventory(let inventory):
            return .inventory(inventory.reduce { $0.units })
        case .null:
            return .null
        default:
            throw BQLExecutionError.invalidType
        }
    }

    private func cost(_ value: RuntimeValue) throws -> RuntimeValue {
        switch value {
        case .int, .decimal, .amount:
            return value
        case .position(let position):
            return .amount(position.totalCost)
        case .inventory(let inventory):
            return .inventory(inventory.reduce { $0.totalCost })
        case .null:
            return .null
        default:
            throw BQLExecutionError.invalidType
        }
    }

    private func weight(_ value: RuntimeValue) throws -> RuntimeValue {
        switch value {
        case .int, .decimal, .amount:
            return value
        case .position(let position):
            return .amount(position.weight)
        case .inventory(let inventory):
            return .inventory(inventory.reduce { $0.weight })
        case .null:
            return .null
        default:
            throw BQLExecutionError.invalidType
        }
    }

    private func value(_ input: RuntimeValue, date: Date?) throws -> RuntimeValue {
        switch input {
        case .int, .decimal, .amount:
            return input

        case .position(let position):
            guard let priceMap = context.priceMap else {
                return .amount(position.units)
            }
            return .amount(position.marketValue(from: priceMap, date: date))

        case .inventory(let inventory):
            guard let priceMap = context.priceMap else {
                return .inventory(inventory.reduce { $0.units })
            }
            return .inventory(inventory.reduce { $0.marketValue(from: priceMap, date: date) })

        case .null:
            return .null

        default:
            throw BQLExecutionError.invalidType
        }
    }

    private func convert(
        _ input: RuntimeValue,
        targetCurrency: String,
        date: Date?
    ) throws -> RuntimeValue {
        let target = Currency(id: targetCurrency.uppercased())

        switch input {
        case .amount(let amount):
            guard let priceMap = context.priceMap else {
                return .amount(amount)
            }
            return .amount(convertAmount(amount, to: target, priceMap: priceMap, date: date))

        case .position(let position):
            guard let priceMap = context.priceMap else {
                return .amount(position.units)
            }
            return .amount(position.converted(to: target, priceMap: priceMap, date: date))

        case .inventory(let inventory):
            guard let priceMap = context.priceMap else {
                return .inventory(inventory.reduce { $0.units })
            }
            return .inventory(
                inventory.reduce { position in
                    position.converted(to: target, priceMap: priceMap, date: date)
                }
            )

        case .null:
            return .null

        default:
            throw BQLExecutionError.invalidType
        }
    }

    private func getprice(
        base: String,
        quote: String,
        date: Date?
    ) -> RuntimeValue {
        guard let priceMap = context.priceMap else {
            return .null
        }
        let pair = CurrencyPair(
            base: Currency(id: base.uppercased()),
            quote: Currency(id: quote.uppercased())
        )
        guard let price = priceMap.price(for: pair, date: date) else {
            return .null
        }
        return .decimal(price.rate)
    }

    private func number(_ value: RuntimeValue) throws -> RuntimeValue {
        switch value {
        case .amount(let amount):
            return .decimal(amount.number)
        case .null:
            return .null
        default:
            throw BQLExecutionError.invalidType
        }
    }

    private func currency(_ value: RuntimeValue) throws -> RuntimeValue {
        switch value {
        case .amount(let amount):
            return .string(amount.currency.id)
        case .null:
            return .null
        default:
            throw BQLExecutionError.invalidType
        }
    }

    private func only(currency: String, inventory: RuntimeValue) throws -> RuntimeValue {
        switch inventory {
        case .inventory(let inventory):
            return .amount(inventory.getCurrencyUnits(in: Currency(id: currency.uppercased())))
        case .null:
            return .null
        default:
            throw BQLExecutionError.invalidType
        }
    }

    private func empty(_ value: RuntimeValue) throws -> RuntimeValue {
        switch value {
        case .inventory(let inventory):
            return .bool(inventory.isEmpty)
        case .null:
            return .null
        default:
            throw BQLExecutionError.invalidType
        }
    }

    private func filterCurrency(_ value: RuntimeValue, currency: String) throws -> RuntimeValue {
        let target = Currency(id: currency.uppercased())
        switch value {
        case .position(let position):
            return position.units.currency == target ? .position(position) : .null
        case .inventory(let inventory):
            return .inventory(inventory.filtered(by: target))
        case .null:
            return .null
        default:
            throw BQLExecutionError.invalidType
        }
    }

    private func possign(_ value: RuntimeValue, account: String) throws -> RuntimeValue {
        guard accountSign(account) < 0 else {
            return value
        }

        switch value {
        case .int(let int):
            return .int(-int)
        case .decimal(let decimal):
            return .decimal(-decimal)
        case .amount(let amount):
            return .amount(-amount)
        case .position(let position):
            return .position(-position)
        case .inventory(let inventory):
            return .inventory(-inventory)
        case .null:
            return .null
        default:
            throw BQLExecutionError.invalidType
        }
    }

    private func convertAmount(
        _ amount: Amount,
        to targetCurrency: Currency,
        priceMap: PriceMap,
        date: Date?,
        via: [Currency]? = nil
    ) -> Amount {
        if amount.currency == targetCurrency {
            return amount
        }

        let direct = CurrencyPair(base: amount.currency, quote: targetCurrency)
        if let price = priceMap.price(for: direct, date: date) {
            return Amount(number: amount.number * price.rate, currency: targetCurrency)
        }

        if let via {
            for implied in via where implied != targetCurrency {
                let firstHop = CurrencyPair(base: amount.currency, quote: implied)
                guard let firstPrice = priceMap.price(for: firstHop, date: date) else {
                    continue
                }

                let secondHop = CurrencyPair(base: implied, quote: targetCurrency)
                guard let secondPrice = priceMap.price(for: secondHop, date: date) else {
                    continue
                }

                return Amount(
                    number: amount.number * firstPrice.rate * secondPrice.rate,
                    currency: targetCurrency
                )
            }
        }

        return amount
    }

    private func accountSign(_ account: String) -> Int {
        let root = account.split(separator: ":").first?.lowercased() ?? account.lowercased()
        switch root {
        case "liabilities", "equity", "income":
            return -1
        default:
            return 1
        }
    }

    private func accountRoot(_ account: String, components requestedCount: Int) -> String {
        let components = account.split(separator: ":", omittingEmptySubsequences: false).map(String.init)
        if requestedCount >= 0 {
            return components.prefix(requestedCount).joined(separator: ":")
        }

        let dropCount = min(-requestedCount, components.count)
        return components.dropLast(dropCount).joined(separator: ":")
    }

    private func parentAccount(_ account: String) -> String? {
        guard !account.isEmpty else {
            return nil
        }
        var components = account.split(separator: ":", omittingEmptySubsequences: false).map(String.init)
        _ = components.popLast()
        return components.joined(separator: ":")
    }

    private func leafAccount(_ account: String) -> String? {
        guard !account.isEmpty else {
            return nil
        }
        return account.split(separator: ":", omittingEmptySubsequences: false).last.map(String.init)
    }

    private func lookupAccount(_ account: String) -> QueryRow? {
        guard let accounts = context.tables["accounts"] else {
            return nil
        }

        return accounts.first { row in
            guard case .string(let accountName) = row["account"] else {
                return false
            }
            return accountName == account
        }
    }

    private func accountSortIndex(_ account: String) -> Int {
        let root = account.split(separator: ":").first?.lowercased() ?? account.lowercased()
        switch root {
        case "assets":
            return 0
        case "liabilities":
            return 1
        case "equity":
            return 2
        case "income":
            return 3
        case "expenses":
            return 4
        default:
            return 5
        }
    }

    private func firstRegexMatch(pattern: String, in input: String) -> String? {
        guard let regex = try? Regex(pattern),
              let match = input.firstMatch(of: regex)
        else {
            return nil
        }
        return String(input[match.range])
    }

    private func regexGroup(pattern: String, in input: String, index: Int) -> String? {
        guard index >= 0,
              let regex = try? Regex(pattern),
              let match = input.firstMatch(of: regex)
        else {
            return nil
        }
        guard index < match.output.count,
              let substring = match.output[index].substring
        else {
            return nil
        }
        return String(substring)
    }

    private func substituteRegex(pattern: String, replacement: String, in input: String) -> String? {
        guard let regex = try? Regex(pattern) else { return nil }
        return input.replacing(regex) { match in
            var result = ""
            var iterator = replacement.makeIterator()
            var pendingBackslash = false
            while let ch = iterator.next() {
                if pendingBackslash {
                    if ch.isNumber,
                       let digit = ch.wholeNumberValue,
                       digit < match.output.count,
                       let sub = match.output[digit].substring {
                        result.append(contentsOf: sub)
                    } else {
                        result.append(ch)
                    }
                    pendingBackslash = false
                    continue
                }
                if ch == "\\" {
                    pendingBackslash = true
                    continue
                }
                result.append(ch)
            }
            return result
        }
    }

    private func asStringList(_ value: RuntimeValue) -> [String]? {
        guard case .list(let values) = value else {
            return nil
        }

        var result: [String] = []
        result.reserveCapacity(values.count)
        for value in values {
            guard case .string(let stringValue) = value else {
                return nil
            }
            result.append(stringValue)
        }
        return result
    }

    private func findFirst(pattern: String, in values: [String]) -> String? {
        guard !values.isEmpty,
              let regex = try? Regex(pattern)
        else {
            return nil
        }

        for candidate in values.sorted() {
            if candidate.prefixMatch(of: regex) != nil {
                return candidate
            }
        }
        return nil
    }

    private func rowHasAccount(row: QueryRow?, pattern: String) -> Bool {
        guard let row,
              let regex = try? Regex(pattern)
        else {
            return false
        }

        func matches(_ value: String) -> Bool {
            value.contains(regex)
        }

        if case .list(let values) = row["accounts"] {
            for value in values {
                guard case .string(let account) = value else { continue }
                if matches(account) {
                    return true
                }
            }
        }

        if case .string(let account) = row["account"] {
            return matches(account)
        }

        return false
    }

    private func asInt(_ value: RuntimeValue) -> Int? {
        if case .int(let int) = value {
            return int
        }
        return nil
    }

    private func dateCalendar() -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone.current
        return calendar
    }

    private func isoCalendar() -> Calendar {
        var calendar = Calendar(identifier: .iso8601)
        calendar.timeZone = TimeZone.current
        return calendar
    }

    private func dateParts(_ date: Date) -> (year: Int, month: Int, day: Int) {
        let components = dateCalendar().dateComponents([.year, .month, .day], from: date)
        return (components.year ?? 0, components.month ?? 0, components.day ?? 0)
    }

    private func buildDate(year: Int, month: Int, day: Int) -> Date? {
        var components = DateComponents()
        components.calendar = dateCalendar()
        components.year = year
        components.month = month
        components.day = day
        return components.date
    }

    private func normalizeDate(_ date: Date) -> Date? {
        let parts = dateParts(date)
        return buildDate(year: parts.year, month: parts.month, day: parts.day)
    }

    private func today() -> Date {
        normalizeDate(Date()) ?? Date()
    }

    private func addDays(_ date: Date, _ days: Int) -> Date? {
        dateCalendar().date(byAdding: .day, value: days, to: date).flatMap(normalizeDate)
    }

    private func addStride(_ date: Date, stride: DateStride) -> Date? {
        var components = DateComponents()
        components.year = stride.years
        components.month = stride.months
        components.day = stride.days
        return dateCalendar().date(byAdding: components, to: date).flatMap(normalizeDate)
    }

    private func daysBetween(_ start: Date, _ end: Date) -> Int? {
        dateCalendar().dateComponents([.day], from: start, to: end).day
    }

    private func weekdayAbbreviation(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = dateCalendar()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }

    private func parseDateExactYMD(_ input: String) -> Date? {
        parseDate(input, withSwiftFormat: "yyyy-MM-dd")
    }

    private func parseDate(_ input: String) -> Date? {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)

        if let date = parseDateExactYMD(trimmed) {
            return date
        }

        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.timeZone = TimeZone.current
        let isoOptions: [ISO8601DateFormatter.Options] = [
            [.withFullDate],
            [.withInternetDateTime],
            [.withInternetDateTime, .withFractionalSeconds],
        ]
        for options in isoOptions {
            isoFormatter.formatOptions = options
            if let date = isoFormatter.date(from: trimmed), let normalized = normalizeDate(date) {
                return normalized
            }
        }

        let formats = [
            "yyyy/MM/dd",
            "yyyyMMdd",
            "yyyy-MM-dd HH:mm:ss",
            "yyyy-MM-dd HH:mm",
            "yyyy-MM-dd'T'HH:mm:ss",
            "yyyy-MM-dd'T'HH:mm:ssXXXXX",
            "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX",
            "MMM d, yyyy",
            "MMMM d, yyyy",
        ]
        for format in formats {
            if let date = parseDate(trimmed, withSwiftFormat: format) {
                return date
            }
        }

        return nil
    }

    private func parseDate(_ input: String, withPythonFormat format: String) -> Date? {
        parseDate(input, withSwiftFormat: swiftDateFormat(fromPython: format))
    }

    private func parseDate(_ input: String, withSwiftFormat format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.calendar = dateCalendar()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = format
        formatter.isLenient = false
        guard let parsed = formatter.date(from: input) else {
            return nil
        }
        return normalizeDate(parsed)
    }

    private func swiftDateFormat(fromPython format: String) -> String {
        var output = ""
        var index = format.startIndex

        while index < format.endIndex {
            let char = format[index]
            guard char == "%" else {
                output.append(char)
                index = format.index(after: index)
                continue
            }

            let nextIndex = format.index(after: index)
            guard nextIndex < format.endIndex else {
                break
            }

            let token = format[nextIndex]
            switch token {
            case "Y":
                output.append("yyyy")
            case "y":
                output.append("yy")
            case "m":
                output.append("MM")
            case "d":
                output.append("dd")
            case "e":
                output.append("d")
            case "H":
                output.append("HH")
            case "I":
                output.append("hh")
            case "M":
                output.append("mm")
            case "S":
                output.append("ss")
            case "b":
                output.append("MMM")
            case "B":
                output.append("MMMM")
            case "a":
                output.append("EEE")
            case "A":
                output.append("EEEE")
            case "j":
                output.append("DDD")
            case "%":
                output.append("%")
            default:
                output.append(token)
            }

            index = format.index(after: nextIndex)
        }

        return output
    }

    private func dateTrunc(field: String, date: Date) -> Date? {
        let normalizedField = field.lowercased()
        let parts = dateParts(date)

        switch normalizedField {
        case "week":
            let weekday = pythonWeekday(date)
            return addDays(date, -weekday)
        case "month":
            return buildDate(year: parts.year, month: parts.month, day: 1)
        case "quarter":
            let month = parts.month - (parts.month - 1) % 3
            return buildDate(year: parts.year, month: month, day: 1)
        case "year":
            return buildDate(year: parts.year, month: 1, day: 1)
        case "decade":
            return buildDate(year: parts.year - parts.year % 10, month: 1, day: 1)
        case "century":
            return buildDate(year: parts.year - (parts.year - 1) % 100, month: 1, day: 1)
        case "millennium":
            return buildDate(year: parts.year - (parts.year - 1) % 1000, month: 1, day: 1)
        default:
            return nil
        }
    }

    private func datePart(field: String, date: Date) -> Int? {
        let normalizedField = field.lowercased()
        let parts = dateParts(date)
        let iso = isoCalendar()

        switch normalizedField {
        case "weekday", "dow":
            return pythonWeekday(date)
        case "isoweekday", "isodow":
            return pythonWeekday(date) + 1
        case "week":
            return iso.component(.weekOfYear, from: date)
        case "month":
            return parts.month
        case "quarter":
            return (parts.month - 1) / 3 + 1
        case "year":
            return parts.year
        case "isoyear":
            return iso.component(.yearForWeekOfYear, from: date)
        case "decade":
            return parts.year / 10
        case "century":
            return (parts.year - 1) / 100 + 1
        case "millennium":
            return (parts.year - 1) / 1000 + 1
        case "epoch":
            guard let epoch = buildDate(year: 1970, month: 1, day: 1),
                  let days = daysBetween(epoch, date)
            else {
                return nil
            }
            return days * 86_400
        default:
            return nil
        }
    }

    private func pythonWeekday(_ date: Date) -> Int {
        let weekday = dateCalendar().component(.weekday, from: date)
        return (weekday + 5) % 7
    }

    private func parseInterval(_ input: String) -> DateStride? {
        let parts = input
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
            .split(whereSeparator: \.isWhitespace)

        guard parts.count == 2, let number = Int(parts[0]) else {
            return nil
        }

        var unit = String(parts[1])
        if unit.hasSuffix("s") {
            unit.removeLast()
        }

        switch unit {
        case "day":
            return DateStride(years: 0, months: 0, days: number)
        case "week":
            return DateStride(years: 0, months: 0, days: number * 7)
        case "month":
            return DateStride(years: 0, months: number, days: 0)
        case "year":
            return DateStride(years: number, months: 0, days: 0)
        case "decade":
            return DateStride(years: number * 10, months: 0, days: 0)
        case "century":
            return DateStride(years: number * 100, months: 0, days: 0)
        case "millennium":
            return DateStride(years: number * 1000, months: 0, days: 0)
        default:
            return nil
        }
    }

    private func dateBin(stride: DateStride, source: Date, origin: Date) -> Date? {
        guard let normalizedSource = normalizeDate(source),
              let normalizedOrigin = normalizeDate(origin)
        else {
            return nil
        }

        if stride.hasMonthOrYearComponent {
            guard let next = addStride(normalizedOrigin, stride: stride), next > normalizedOrigin else {
                return nil
            }

            if normalizedSource >= normalizedOrigin {
                var lowerBound = normalizedOrigin
                var cursor = normalizedOrigin
                while true {
                    guard let nextCursor = addStride(cursor, stride: stride) else {
                        return nil
                    }
                    if nextCursor >= normalizedSource {
                        return lowerBound
                    }
                    lowerBound = nextCursor
                    cursor = nextCursor
                }
            } else {
                var cursor = normalizedOrigin
                while true {
                    guard let nextCursor = addStride(cursor, stride: stride.negated) else {
                        return nil
                    }
                    if nextCursor <= normalizedSource {
                        return nextCursor
                    }
                    cursor = nextCursor
                }
            }
        }

        guard let dayStride = stride.dayStride, dayStride > 0,
              let diffDays = daysBetween(normalizedOrigin, normalizedSource)
        else {
            return nil
        }

        let modulo = diffDays % dayStride
        var delta = diffDays - modulo
        if modulo < 0 {
            delta -= dayStride
        }
        return addDays(normalizedOrigin, delta)
    }
}
