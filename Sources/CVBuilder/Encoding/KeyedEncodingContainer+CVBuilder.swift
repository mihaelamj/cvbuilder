import Foundation

extension KeyedEncodingContainer {
    /// Encodes `value` only when it is a non-empty string.
    ///
    /// Used by the JSON Resume model so canonical output omits empty optional
    /// fields instead of emitting `""`, keeping exported documents faithful to
    /// the JSON Resume convention of absent rather than empty values.
    mutating func encodeIfNotEmpty(_ value: String, forKey key: Key) throws {
        guard !value.isEmpty else {
            return
        }

        try encode(value, forKey: key)
    }

    /// Encodes `value` only when the collection is non-empty.
    mutating func encodeIfNotEmpty(_ value: [some Encodable], forKey key: Key) throws {
        guard !value.isEmpty else {
            return
        }

        try encode(value, forKey: key)
    }
}
