import Foundation

/// Stateless `URLProtocol` stub: the response is derived from the request URL's
/// last path component, so concurrent tests never share mutable state.
final class StubURLProtocol: URLProtocol {
    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        switch request.url?.lastPathComponent {
        case "cancelled":
            client?.urlProtocol(self, didFailWithError: URLError(.cancelled))
        case "timeout":
            client?.urlProtocol(self, didFailWithError: URLError(.timedOut))
        default:
            client?.urlProtocol(self, didFailWithError: URLError(.unsupportedURL))
        }
    }

    override func stopLoading() {}
}

extension URLSession {
    /// A session whose every request is served by `StubURLProtocol`.
    static var stubbed: URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [StubURLProtocol.self]
        return URLSession(configuration: configuration)
    }
}
