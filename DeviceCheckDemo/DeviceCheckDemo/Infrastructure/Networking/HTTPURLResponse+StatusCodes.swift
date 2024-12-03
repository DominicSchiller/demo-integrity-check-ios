import Foundation

extension HTTPURLResponse {
    
    /// Status whether the request is still being processed or not.
    var isInformational: Bool {
        100 ... 199 ~= statusCode
    }
    
    /// Status whether the request has been succeeded or not
    var isSuccess: Bool {
        200...299 ~= statusCode
    }
    
    
    /// Status whether some redirection is required to continue with the request or not.
    var isRedirection: Bool {
        300...399 ~= statusCode
    }
    
    /// Status if an error has been occurred whose failure caused by the client.
    var isClientError: Bool {
        400...499 ~= statusCode
    }
    
    /// Status if an error has been occurred whose failure caused by the server.
    var isServerError: Bool {
        500...599 ~= statusCode
    }
    
    /// Status whether a client or server error has been occurred.
    var isError: Bool {
        isClientError || isServerError
    }
    
}
