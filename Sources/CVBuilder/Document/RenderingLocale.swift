import Foundation

/// The output language for rendered section labels, field labels, and month
/// names, selected through `RenderingOptions.locale`.
///
/// A locale resolves to a fixed `RenderingLabels` set. Rendering never consults
/// the host `Locale` or `Calendar`, so the same document and locale always
/// produce byte-for-byte identical Markdown. The default is `.english`.
public enum RenderingLocale: String, Codable, CaseIterable, Sendable {
    case english = "en"
    case german = "de"

    /// The label set the renderer uses for this locale.
    public var labels: RenderingLabels {
        switch self {
        case .english:
            .english
        case .german:
            .german
        }
    }
}
