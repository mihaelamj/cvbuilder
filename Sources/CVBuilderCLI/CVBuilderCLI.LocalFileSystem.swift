import Foundation

public extension CVBuilderCLI {
    /// Production filesystem adapter backed by Foundation `FileManager` and `Data` file IO.
    struct LocalFileSystem: FileSystem {
        private let fileManager: FileManager

        /// Creates a local filesystem adapter with its `FileManager` supplied by the composition root.
        public init(fileManager: FileManager) {
            self.fileManager = fileManager
        }

        /// Reads a complete file from the local filesystem.
        public func readFile(atPath path: String) throws -> Data {
            try Data(contentsOf: URL(fileURLWithPath: path))
        }

        /// Returns whether the local filesystem contains an item at `path`.
        public func fileExists(atPath path: String) -> Bool {
            fileManager.fileExists(atPath: path)
        }

        /// Creates a directory on the local filesystem.
        public func createDirectory(at url: URL, withIntermediateDirectories: Bool) throws {
            try fileManager.createDirectory(
                at: url,
                withIntermediateDirectories: withIntermediateDirectories,
            )
        }

        /// Writes data atomically to the local filesystem.
        public func write(_ data: Data, to url: URL) throws {
            try data.write(to: url, options: .atomic)
        }
    }
}
