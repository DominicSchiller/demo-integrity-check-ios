@testable import DeviceCheckDemo

/// An ``APIRequest`` Mock.
struct MockRequest: APIRequest {
    
    var body: HTTPBody? { nil }
    
    var endpoint: String
    
    var headers: HTTPHeaders? { nil }
    
    var method: HTTPMethod
    
    init(
        endpoint:String,
        method: HTTPMethod = .get
    ) {
        self.endpoint = endpoint
        self.method = method
    }
}
