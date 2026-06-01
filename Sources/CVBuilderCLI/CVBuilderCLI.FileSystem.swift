import Foundation

public extension CVBuilderCLI {
    /// File operations required by `Runner` to read inputs, compare checked outputs, and write rendered artifacts.
    protocol FileSystem {
        /// Reads the complete file contents at `path`.
        func readFile(atPath path: String) throws -> Data

        /// Returns whether a filesystem item exists at `path`.
        func fileExists(atPath path: String) -> Bool

        /// Creates the directory at `url`, optionally creating intermediate directories.
        func createDirectory(at url: URL, withIntermediateDirectories: Bool) throws

        /// Writes `data` to `url` atomically.
        func write(_ data: Data, to url: URL) throws
    }
}
