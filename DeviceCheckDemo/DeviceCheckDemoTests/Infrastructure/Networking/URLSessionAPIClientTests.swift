import Foundation
import Testing
@testable import DeviceCheckDemo

@Suite("API Client Tests")
@MainActor // > Important: Fix for error: the replacement path doesn't exist
class URLSessionAPIClientTests {

    typealias HTTPURLResponseBuilder = (String) throws -> HTTPURLResponse
    
    // MARK: - Properties
    // MARK: - Responses
    
    private func http200Response(endpoint: String) throws -> HTTPURLResponse {
        try httpResponse(endpoint: endpoint, statusCode: 200)
    }
    
    private func http401Response(endpoint: String) throws -> HTTPURLResponse {
        try httpResponse(endpoint: endpoint, statusCode: 401)
    }
    
    private func httpResponse(endpoint: String, statusCode: Int) throws -> HTTPURLResponse {
        try #require(
            HTTPURLResponse(
                url: url(for: endpoint) ,
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: nil
            )
        )
    }
    
    // MARK: - SUT
    
    private func url(for urlString: String) throws -> URL {
        try #require(URL(string: urlString))
    }
    
    private func makeSUT(
        serving responses: [(url: String, httpResponse: HTTPURLResponseBuilder, data: Data)]
    ) throws -> URLSessionAPIClient {
        
        let baseURLString = "http://127.0.0.1:8088"
        let baseURL = try url(for: baseURLString)
        
        // assigning mock response data
        for response in responses {
            let url = baseURL.appending(path: response.url)
            let httpResponse = try response.httpResponse(response.url)
            MockURLProtocol.mockResponses[url] = (
                response: httpResponse,
                data: response.data
            )
        }
        
        // Set up a custom URLSession using the mock protocol
        let config = URLSessionConfiguration.default
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        
        return URLSessionAPIClient(
            baseURL: baseURLString,
            session: session
        )
    }
    
    // MARK: - Tests
    
    @Test
    func test_givenHttp200Response_withoutAnyData_whenSendingRequest_thenExpectNoErrorThrown() async throws {
        // GIVEN
        let request = MockRequest(
            endpoint: UUID().uuidString
        )
        let sut = try makeSUT(serving: [
            (
                url: request.endpoint,
                httpResponse: http200Response(endpoint:),
                data: Data()
            )
        ])
        
        // THEN
        await #expect(throws: Never.self) {
            // WHEN
            try await sut.send(request: request)
        }
    }
    
    @Test
    func test_givenHttp200Response_withStringData_whenSendingRequest_thenExpectDecodedString() async throws {
        // GIVEN
        let request = MockRequest(
            endpoint: UUID().uuidString
        )
        let sut = try makeSUT(serving: [
            (
                url: request.endpoint,
                httpResponse: http200Response(endpoint:),
                data: Data("Hello, world".utf8)
            )
        ])
        
        // WHEN
        let result: String = try await sut.send(request: request)
        
        // THEN
        #expect(result == "Hello, world")
    }
    
    @Test
    func test_givenHttp200Response_withJSONData_whenSendingRequest_thenExpectCustomDecodedType() async throws {
        // GIVEN
        let request = MockRequest(
            endpoint: UUID().uuidString
        )
        let sut = try makeSUT(serving: [
            (
                url: request.endpoint,
                httpResponse: http200Response(endpoint:),
                data: Data(
                    #"""
                    {
                      "title": "hello",
                      "message": "world"
                    }
                    """#.utf8
                )
            )
        ])
        
        // WHEN
        let result: MockDecodableResponseType = try await sut.send(request: request)
        
        // THEN
        let expectedResult = MockDecodableResponseType(title: "hello", message: "world")
        #expect(result == expectedResult)
    }
    
    @Test
    func test_givenHttp200Response_withWrongData_whenSendingRequest_thenExpectThrowingError() async throws {
        // GIVEN
        let request = MockRequest(
            endpoint: UUID().uuidString
        )
        let sut = try makeSUT(serving: [
            (
                url: request.endpoint,
                httpResponse: http200Response(endpoint:),
                data: Data("Hello, world".utf8)
            )
        ])
        
        // THEN
        await #expect(throws: URLSessionAPIClientError.self) {
            // WHEN
            try await sut.send(request: request) as MockDecodableResponseType
        }
    }
    
    @Test
    func test_givenHttp401Response_whenSendingRequest_thenExpectThrowingHttpError() async throws {
        // GIVEN
        let request = MockRequest(
            endpoint: UUID().uuidString
        )
        let sut = try makeSUT(serving: [
            (
                url: request.endpoint,
                httpResponse: http401Response(endpoint:),
                data: Data()
            )
        ])
        
        do {
            // WHEN
            try await sut.send(request: request)
            Issue.record("An HTTP 401 Error should be thrown")
        } catch {
            // THEN
            switch error {
            case let .http(statusCode, _):
                #expect(statusCode == 401)
            default:
                Issue.record("An HTTP 401 Error should be thrown instead of \(error)")
            }
        }
        
    }
}
