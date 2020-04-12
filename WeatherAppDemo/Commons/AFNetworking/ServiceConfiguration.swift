import Foundation
import Alamofire

private struct Constants {
    static let environmentKey = "Environment"
    static let weatherAPIHashKey = "APIHash"
}

public class ServiceConfiguration {

    public static func getAPIHash() -> String? {
        guard let endpointDictionary = Bundle.main.object(forInfoDictionaryKey: Constants.environmentKey) as? [String: Any],
        let weatherAPIKeyString = endpointDictionary[Constants.weatherAPIHashKey] as? String else { return nil }
        return weatherAPIKeyString
    }

    public static var `sessionManager`: SessionManager = ServiceConfiguration.manager
    
    private static let `manager`: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        let sessionDelegate = SessionDelegate()
        return SessionManager(configuration: configuration, delegate: sessionDelegate)
    }()
}
