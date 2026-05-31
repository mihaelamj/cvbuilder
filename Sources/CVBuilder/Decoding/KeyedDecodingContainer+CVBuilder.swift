import Foundation

extension KeyedDecodingContainer {
    func decodeIfPresent<T: Decodable>(
        _ type: T.Type,
        forKey key: Key,
        default defaultValue: @autoclosure () -> T
    ) throws -> T {
        try decodeIfPresent(type, forKey: key) ?? defaultValue()
    }
}
