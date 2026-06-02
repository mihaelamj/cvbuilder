import Foundation

extension KeyedDecodingContainer {
    func decode<T: Decodable>(
        _ type: T.Type,
        forKey key: Key,
        defaultIfMissing defaultValue: @autoclosure () -> T,
    ) throws -> T {
        guard contains(key) else {
            return defaultValue()
        }

        return try decode(type, forKey: key)
    }

    /// Decodes a value that may be omitted but must never be an explicit `null`.
    ///
    /// A missing key yields `nil`, which lets the synthesized encoder omit the
    /// field again so normalized JSON stays byte-stable for documents that
    /// author no value (notably omitted `id`s). An explicit JSON `null` is
    /// rejected, preserving the contract that null is malformed rather than a
    /// silent default.
    func decodeOmittable<T: Decodable>(_ type: T.Type, forKey key: Key) throws -> T? {
        guard contains(key) else {
            return nil
        }

        return try decode(type, forKey: key)
    }
}
