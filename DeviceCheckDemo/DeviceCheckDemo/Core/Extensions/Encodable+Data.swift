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
        try JSONEncoder().encode(self)
    }
    
}

