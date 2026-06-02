import Foundation

public extension CVBuilderCLI {
    /// Standard input and output boundary used by authoring commands.
    protocol StandardIO {
        /// Reads all currently available standard input data.
        func readStandardInput() throws -> Data

        /// Writes bytes to standard output.
        func writeStandardOutput(_ data: Data) throws
    }

    /// Production standard IO adapter backed by Foundation `FileHandle`.
    struct LocalStandardIO: StandardIO {
        /// Creates a local standard IO adapter.
        public init() {}

        /// Reads standard input to end of file.
        public func readStandardInput() throws -> Data {
            FileHandle.standardInput.readDataToEndOfFile()
        }

        /// Writes bytes to standard output.
        public func writeStandardOutput(_ data: Data) throws {
            FileHandle.standardOutput.write(data)
        }
    }
}
