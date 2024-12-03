import Foundation

extension Data {
    
    /// Tries to decode the `Data` to the requested `Decodable` type.
    /// - Returns: The decoded type.
    /// - Throws: An error if any value throws an error during decoding.
    func decoded<Result: Decodable>() throws -> Result {
        try decode()
    }
    
    private func decode<Result: Decodable>() throws -> Result {
        try JSONDecoder().decode(Result.self, from: self)
    }
    
}
