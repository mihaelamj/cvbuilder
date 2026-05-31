import Foundation

extension KeyedDecodingContainer {
    func decode<T: Decodable>(
        _ type: T.Type,
        forKey key: Key,
        defaultIfMissing defaultValue: @autoclosure () -> T
    ) throws -> T {
        guard contains(key) else {
            return defaultValue()
        }

        return try decode(type, forKey: key)
    }
}
