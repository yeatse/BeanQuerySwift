import BeancountSwift

extension RuntimeValue {
    func negated() throws -> RuntimeValue {
        switch self {
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
}
