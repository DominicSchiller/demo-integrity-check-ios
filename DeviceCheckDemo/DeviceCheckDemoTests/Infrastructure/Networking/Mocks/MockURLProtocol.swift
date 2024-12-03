import Foundation

/// A `URLProtocol` Mock to serve mock responses to certain requests.
class MockURLProtocol: URLProtocol {
    /// Dictionary of stored mock responses for specific URLs
    static var mockResponses: [URL: (response: HTTPURLResponse, data: Data)] = [:]

    override class func canInit(with request: URLRequest) -> Bool {
        // Handle all requests
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard
            let url = request.url,
            let mockResponse = MockURLProtocol.mockResponses[url]
        else {
            // Return a 404-like error if no mock data is set for the URL
            let error = NSError(domain: "MockURLProtocol", code: 404, userInfo: [NSLocalizedDescriptionKey: "No mock data found"])
            client?.urlProtocol(self, didFailWithError: error)
            return
        }

        // Simulate a response and send the mock data
        client?.urlProtocol(self, didReceive: mockResponse.response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: mockResponse.data)
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {
        // No action needed
    }
}
