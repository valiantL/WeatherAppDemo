import Foundation

final class MockURLProtocol: URLProtocol {

    enum ResponseType {
        case success(HTTPURLResponse, Data?)
    }
    static var responseType: ResponseType!

    private lazy var session: URLSession = {
        let configuration: URLSessionConfiguration = URLSessionConfiguration.ephemeral
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()

//    used to store the task that we will create in startLoading()
    private(set) var activeTask: URLSessionTask?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return false
    }

    override func startLoading() {
//        this is where we create a url session task and cancel it to trigger the didCompleteWithError delegate function
        activeTask = session.dataTask(with: request.urlRequest!)
        activeTask?.cancel()
    }

    override func stopLoading() {
//        we cancel immediately the request task because we don't want the API to continue
        activeTask?.cancel()
    }
}

// MARK: - URLSessionDataDelegate
extension MockURLProtocol: URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        switch MockURLProtocol.responseType {
        case .success(let response, let value)?:
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            if let data = value {
                client?.urlProtocol(self, didLoad: data)
            }
        default:
            break
        }
        client?.urlProtocolDidFinishLoading(self)
    }
}

extension MockURLProtocol {
    
    static func responseWithStatusCode(code: Int, data: Data?) {
        MockURLProtocol.responseType = MockURLProtocol.ResponseType.success(HTTPURLResponse(url: URL(string: "http://discovery.co.za")!, statusCode: code, httpVersion: nil, headerFields: nil)!, data)
    }
}
