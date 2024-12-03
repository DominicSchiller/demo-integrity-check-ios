import Foundation

/// A concrete ``APIClient`` implementation which uses an `URLSession` instance to send network requests.
class URLSessionAPIClient: APIClient {
    
    // MARK: - Properties
    private let baseURL: String
    private let session: URLSession
    
    // MARK: - Init
    
    /// Creates a new instance.
    /// - Parameters:
    ///   - baseURL: The server's base URL which to call
    ///   - session: The `URLSession` instance which to use to sending requests, ***Default = .shared***
    init(baseURL: String, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }
    
    // MARK: - APIClient Implementation
    
    @discardableResult
    func send<ResponseData>(request: any APIRequest) async throws(URLSessionAPIClientError) -> ResponseData where ResponseData : Decodable {
        let responseData = try await sendDataRequest(request)
        return try decode(responseData: responseData)
    }
    
    func send(request: any APIRequest) async throws(URLSessionAPIClientError) -> Void {
        try await sendDataRequest(request)
    }
    
    @discardableResult
    private func sendDataRequest(
        _ request: any APIRequest
    ) async throws(URLSessionAPIClientError) -> Data {
        let urlRequest = try urlRequest(for: request)
        let urlResponse: URLResponse
        let responseData: Data
        
        do {
            (responseData, urlResponse) = try await session.data(for: urlRequest)
        } catch {
            throw URLSessionAPIClientError.sendingRequestFailed
        }
        
        try isSuccessResponse(urlResponse, withData: responseData)
        return responseData
    }
    
    // MARK: - URLRequest Builder
    
    private func urlRequest(for request: any APIRequest) throws(URLSessionAPIClientError) -> URLRequest {
        
        guard
            !baseURL.isEmpty,
            let url = URL(string: baseURL)?.appendingPathComponent(request.endpoint) else {
            throw URLSessionAPIClientError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        
        do {
            urlRequest.httpBody = try request.body?.data
        } catch {
            throw URLSessionAPIClientError.encodingRequestDataFailed
        }
        
        return urlRequest
    }
    
    // MARK: - Response Handling
    
    private func httpUrlResponse(
        for response: URLResponse
    ) throws(URLSessionAPIClientError) -> HTTPURLResponse {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLSessionAPIClientError.invalidResponseReceived
        }
        return httpResponse
    }
    
    // MARK: Status Validation
    
    private func isSuccessResponse(
        _ urlResponse: URLResponse,
        withData responseData: Data
    ) throws(URLSessionAPIClientError) {
        let httpResponse = try httpUrlResponse(for: urlResponse)
        
        guard httpResponse.isSuccess else {
            throw URLSessionAPIClientError.http(
                statusCode: httpResponse.statusCode,
                data: responseData
            )
        }
    }
    
    
    // MARK: Decoding
    
    private func decode<Response>(responseData data: Data) throws(URLSessionAPIClientError) -> Response {
        return switch Response.self {
        case is Void.Type:
            try cast(())
        case is String.Type:
            try cast(String(data: data, encoding: .utf8))
        case let responseType as Decodable.Type:
           try cast(try? JSONDecoder().decode(responseType, from: data))
        default:
            throw URLSessionAPIClientError.decodingResponseDataFailed(
                reason: .unknownType(type: Response.self)
            )
        }
    }
    
    private func cast<DecodedData, Response>(_ decodedData: DecodedData) throws(URLSessionAPIClientError) -> Response {
        guard let response = decodedData as? Response else {
            throw URLSessionAPIClientError.decodingResponseDataFailed(
                reason: .typeCastingMismatch(type: Response.self)
            )
        }
        return response
    }
}
