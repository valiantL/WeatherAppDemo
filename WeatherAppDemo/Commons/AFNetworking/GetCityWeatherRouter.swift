import Foundation
import Alamofire

enum GetCityWeatherRouter: URLRequestConvertible {
    static let baseURLPath = "http://api.openweathermap.org"
    static let baseIconURLPath = "http://openweathermap.org"

    case getCityWeather(cityId: Int, appId: String)
    case getWeatherIcon(String)

    var method: HTTPMethod {
        switch self {
        case .getCityWeather, .getWeatherIcon:
            return .get
        }
    }
    
    var route: String {
        switch self {
        case .getCityWeather:
            return ("/data/2.5/weather")
        case .getWeatherIcon(let codeStr):
            return ("/img/wn/\(codeStr)@2x.png")
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getCityWeather(let cityId, let appId):
            let param = GetCityWeatherParameters(cityId: cityId, appId: appId)
            return param.toJSON()
        case .getWeatherIcon:
            return nil
        }
    }
    
    func getWeatherIconURLPath() throws -> URL {
        return try GetCityWeatherRouter.baseIconURLPath.asURL().appendingPathComponent(route)
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try GetCityWeatherRouter.baseURLPath.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(route))
        urlRequest.httpMethod = self.method.rawValue
        urlRequest.timeoutInterval = TimeInterval(5 * 1000)
        return try URLEncoding.default.encode(urlRequest, with: parameters)
    }
}

struct GetCityWeatherParameters {
    private var cityId: Int
    private var appId: String
    
    public init(cityId: Int, appId: String) {
        self.cityId = cityId
        self.appId = appId
    }
    
    public func toJSON() -> Parameters {
        var parameters: Parameters = [:]
        parameters["id"] = cityId
        parameters["appid"] = appId
        return parameters
    }
}
