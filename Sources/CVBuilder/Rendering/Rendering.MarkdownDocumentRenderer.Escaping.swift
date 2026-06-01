import Foundation

extension Rendering.MarkdownDocumentRenderer {
    func escapedMarkdownText(_ value: String) -> String {
        let normalizedValue = normalizeMarkdownText(value)
        var escaped = ""

        for scalar in normalizedValue.unicodeScalars {
            if shouldEscapeMarkdownScalar(scalar) {
                escaped += "\\"
            }
            escaped += String(scalar)
        }

        return escapeMarkdownLineStart(escaped)
    }

    func escapedFrontMatterKey(_ key: String) -> String {
        guard !key.isEmpty,
              key.unicodeScalars.allSatisfy(isPlainFrontMatterKeyScalar)
        else {
            return escapedFrontMatterScalar(key)
        }

        return key
    }

    func escapedFrontMatterScalar(_ value: String) -> String {
        var escaped = "\""

        for scalar in value.unicodeScalars {
            switch scalar {
            case "\"":
                escaped += "\\\""
            case "\\":
                escaped += "\\\\"
            case "\n":
                escaped += "\\n"
            case "\r":
                escaped += "\\r"
            case "\t":
                escaped += "\\t"
            default:
                if scalar.value < 0x20 || scalar.value == 0x7F {
                    escaped += String(format: "\\u%04X", scalar.value)
                } else {
                    escaped += String(scalar)
                }
            }
        }

        escaped += "\""
        return escaped
    }

    func encodedLinkDestination(_ destination: String) -> String? {
        let trimmedDestination = destination.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedDestination.isEmpty else {
            return nil
        }

        let bytes = Array(trimmedDestination.utf8)
        var result = ""
        var index = 0

        while index < bytes.count {
            let byte = bytes[index]
            if isExistingPercentTriplet(bytes, at: index) {
                result += "%"
                result += String(UnicodeScalar(bytes[index + 1]))
                result += String(UnicodeScalar(bytes[index + 2]))
                index += 3
                continue
            }

            if isAllowedLinkDestinationByte(byte) {
                result += String(UnicodeScalar(byte))
            } else {
                result += String(format: "%%%02X", byte)
            }

            index += 1
        }

        return result
    }
}

private extension Rendering.MarkdownDocumentRenderer {
    enum CharacterByte {
        static let percent = UInt8(ascii: "%")
    }

    func normalizeMarkdownText(_ value: String) -> String {
        var normalized = ""

        for scalar in value.trimmingCharacters(in: .whitespacesAndNewlines).unicodeScalars {
            if scalar.properties.isWhitespace || scalar.value < 0x20 || scalar.value == 0x7F {
                normalized += " "
            } else {
                normalized += String(scalar)
            }
        }

        return normalized
    }

    func shouldEscapeMarkdownScalar(_ scalar: UnicodeScalar) -> Bool {
        switch scalar {
        case "\\", "`", "*", "_", "{", "}", "[", "]", "(", ")", "#", "!", "|", "<", ">":
            true
        default:
            false
        }
    }

    func escapeMarkdownLineStart(_ value: String) -> String {
        if startsWithUnorderedListMarker(value) {
            return "\\\(value)"
        }

        if isHyphenThematicBreak(value) {
            return "\\\(value)"
        }

        return escapeOrderedListMarker(value)
    }

    func escapeOrderedListMarker(_ value: String) -> String {
        var markerIndex = value.startIndex
        while markerIndex < value.endIndex, value[markerIndex].isNumber {
            markerIndex = value.index(after: markerIndex)
        }

        guard markerIndex > value.startIndex,
              markerIndex < value.endIndex,
              value[markerIndex] == "."
        else {
            return value
        }

        let afterMarkerIndex = value.index(after: markerIndex)
        guard afterMarkerIndex < value.endIndex, value[afterMarkerIndex].isWhitespace else {
            return value
        }

        var escapedValue = value
        escapedValue.insert("\\", at: markerIndex)
        return escapedValue
    }

    func startsWithUnorderedListMarker(_ value: String) -> Bool {
        guard let firstCharacter = value.first else {
            return false
        }

        return (firstCharacter == "-" || firstCharacter == "+")
            && value.dropFirst().first?.isWhitespace == true
    }

    func isHyphenThematicBreak(_ value: String) -> Bool {
        value.allSatisfy { $0 == "-" } && value.count >= 3
    }

    func isPlainFrontMatterKeyScalar(_ scalar: UnicodeScalar) -> Bool {
        scalar.properties.isAlphabetic
            || scalar.properties.numericType != nil
            || scalar == "-"
            || scalar == "_"
    }

    func isAllowedLinkDestinationByte(_ byte: UInt8) -> Bool {
        switch byte {
        case UInt8(ascii: "A") ... UInt8(ascii: "Z"),
             UInt8(ascii: "a") ... UInt8(ascii: "z"),
             UInt8(ascii: "0") ... UInt8(ascii: "9"):
            true
        case UInt8(ascii: "-"),
             UInt8(ascii: "."),
             UInt8(ascii: "_"),
             UInt8(ascii: "~"),
             UInt8(ascii: ":"),
             UInt8(ascii: "/"),
             UInt8(ascii: "?"),
             UInt8(ascii: "#"),
             UInt8(ascii: "@"),
             UInt8(ascii: "!"),
             UInt8(ascii: "$"),
             UInt8(ascii: "&"),
             UInt8(ascii: "'"),
             UInt8(ascii: "*"),
             UInt8(ascii: "+"),
             UInt8(ascii: ","),
             UInt8(ascii: ";"),
             UInt8(ascii: "="):
            true
        default:
            false
        }
    }

    func isHexByte(_ byte: UInt8) -> Bool {
        switch byte {
        case UInt8(ascii: "0") ... UInt8(ascii: "9"),
             UInt8(ascii: "A") ... UInt8(ascii: "F"),
             UInt8(ascii: "a") ... UInt8(ascii: "f"):
            true
        default:
            false
        }
    }

    func isExistingPercentTriplet(_ bytes: [UInt8], at index: Int) -> Bool {
        bytes[index] == CharacterByte.percent
            && index + 2 < bytes.count
            && isHexByte(bytes[index + 1])
            && isHexByte(bytes[index + 2])
    }
}
