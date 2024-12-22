import Foundation

extension Data {
    
    /// Tries to decode the `Data` to the requested `Decodable` type.
    /// - Returns: The decoded type.
    /// - Throws: An error if any value throws an error during decoding.
    func decoded<Result: Decodable>() throws -> Result {
        try decode()
    }
    
    /// Pretty formatted JSON string representation with sorted keys
    /// > Note: If the `Data` does not contain any valid UTF-8 encoded JSON data, `nil` will be returned.
    var prettyFormattedJSONString: String? {
        String(data: self, encoding: .utf8)
    }
    
    private func decode<Result: Decodable>() throws -> Result {
        try JSONDecoder().decode(Result.self, from: self)
    }
    
}
