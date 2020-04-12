import XCTest
import Alamofire

extension XCTestCase {
    
    var expectationTimeout: Double {
        get {
            return 10.0
        }
    }
    
    var dispatchDeadline: DispatchTime {
        get {
            return DispatchTime.now() + DispatchTimeInterval.milliseconds(2000)
        }
    }
    
    var mockSessionManager: SessionManager {
        get {
            let configuration = URLSessionConfiguration.default
            configuration.protocolClasses = [MockURLProtocol.self]
            return SessionManager(configuration: configuration)
        }
    }
    
    public func makeExpectation(_ callingFunctionName: String) -> XCTestExpectation {
        return expectation(description: "Expectation failure for \(callingFunctionName)")
    }
    
    func jsonDictionary(url: URL) -> [String: Any]? {
        do {
            let data = try Data(contentsOf: url)
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }

    func readJSONFile(filename file: String,extension ext: String) -> URL? {
        guard let path = Bundle(for: type(of: self)).url(forResource: file, withExtension: ext, subdirectory: "TestDoubles") else {
            return nil
        }
        return path
    }
    
    func getPayloadFromMainBundle(filename: String) -> Data? {
        if let path = Bundle.main.url(forResource: filename, withExtension: "json"){
            guard let json = jsonDictionary(url: path) else {
                XCTFail("incorrect json format")
                return nil
            }
            if let data = try? JSONSerialization.data(withJSONObject: json) {
                return data
            }
            return nil
        } else {
            return nil
        }
    }
    
    func jsonToData(path file: String, extension ext: String) -> Data? {
        guard let path = readJSONFile(filename: file, extension: ext) else {
            XCTFail("file not found")
            return nil
        }
        guard let json = jsonDictionary(url: path) else {
            XCTFail("incorrect json format")
            return nil
        }
        if let data = try? JSONSerialization.data(withJSONObject: json) {
            return data
        }
        return nil
    }
}

