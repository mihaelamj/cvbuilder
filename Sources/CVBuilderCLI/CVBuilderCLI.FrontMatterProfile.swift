import CVBuilder

extension FrontMatterProfile {
    init(argument: String) throws {
        guard let profile = Self(rawValue: argument) else {
            throw CVBuilderCLI.Failure.unknownFrontMatterProfile(argument)
        }

        self = profile
    }

    static var allowedValuesDescription: String {
        allCases.map(\.rawValue).joined(separator: ", ")
    }
}
