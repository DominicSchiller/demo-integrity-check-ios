import Foundation

/// An error thrown by ``URLSessionAPIClient``.
enum URLSessionAPIClientError: Error {
    /// An HTTP error has been occured.
    /// - Parameters:
    ///     - statusCode: The received HTTP status code
    ///     - data: The received response's error data
    case http(statusCode: Int, data: Data)
    /// The specified URL is invalid and could not be invoked.
    case invalidURL
    ///  No HTTP response has been received.
    case invalidResponseReceived
    /// The request could not be sent successfully.
    case sendingRequestFailed
    /// Encoding the request's body data has been failed.
    case encodingRequestDataFailed
    /// Decoding the response's data has been failed.
    /// - Parameter reason: The error reason
    case decodingResponseDataFailed(reason: DecodingErrorReason)
}

extension URLSessionAPIClientError {
    
    enum DecodingErrorReason: CustomStringConvertible {
        var description: String {
            return switch self {
            case let .unknownType(type):
                "Unknown type to dekode data: \(type)"
            case let .typeCastingMismatch(type):
                "The decoded Data could be cast to requested type: \(type)"
            }
        }
        
        
        case unknownType(type: Any.Type)
        case typeCastingMismatch(type: Any.Type)
    }
    
}
