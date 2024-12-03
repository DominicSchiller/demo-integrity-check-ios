import Foundation

/// A network client to handle API requests and responses.
protocol APIClient {
    
    /// Sends an API request and await a response.
    /// - Parameter request: The request which to send.
    /// - Throws: An case of ``URLSessionAPIClientError``
    func send(
        request: any APIRequest
    ) async throws(URLSessionAPIClientError) -> Void
    
    /// Sends an API request and await a response.
    /// - Parameter request: The request which to send.
    /// - Returns: The received and decoded response data.
    /// - Throws: An case of ``URLSessionAPIClientError``
    @discardableResult
    func send<ResponseData: Decodable>(
        request: any APIRequest
    ) async throws(URLSessionAPIClientError) -> ResponseData
}
