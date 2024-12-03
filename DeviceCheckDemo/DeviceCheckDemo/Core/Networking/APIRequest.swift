import Foundation

/// The request for a certain API endpoint.
protocol APIRequest {
    
    /// The request body
    var body: HTTPBody? { get }
    
    /// The API endpoint which to request
    var endpoint: String { get }
    
    /// Dictionary of HTTP headers
    var headers: HTTPHeaders? { get }
    
    /// The HTTP method
    var method: HTTPMethod { get }
}
