
/// The HTTP method which to use in an network request
enum HTTPMethod: String {
    /// The DELETE method
    case delete
    /// The GET method
    case get
    /// The POST method
    case post
    /// The PUT method
    case put
    
    
    /// The HTTP method's `String` representation.
    var rawValue: String {
        "\(self)".uppercased()
    }
}
