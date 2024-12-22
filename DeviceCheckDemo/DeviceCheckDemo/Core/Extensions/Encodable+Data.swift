import Foundation

extension Encodable {
    
    /// The encoded `Data` representation
    /// - Throws: An error if any value throws an error during encoding.
    var data: Data {
        get throws {
            try encode()
        }
    }
    
    private func encode() throws -> Data {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return try jsonEncoder.encode(self)
    }
    
}

