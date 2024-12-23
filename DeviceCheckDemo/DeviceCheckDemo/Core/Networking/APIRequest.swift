import Foundation

/// The request for a certain API endpoint.
protocol APIRequest {
    
    /// The request's body data
    associatedtype RequestBody: HTTPBody = EmptyHTTPBody
    
    /// The request body
    var body: RequestBody? { get }
    
    /// The API endpoint which to request
    var endpoint: String { get }
    
    /// Dictionary of HTTP headers
    var headers: HTTPHeaders { get }
    
    /// The HTTP method
    var method: HTTPMethod { get }
}

extension APIRequest {
    var body: EmptyHTTPBody? { nil }
    
    var headers: HTTPHeaders {
        [:]
    }
    
}
