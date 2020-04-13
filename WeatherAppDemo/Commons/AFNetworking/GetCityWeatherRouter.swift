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
    
    var parameters: [String: Any]? {
        switch self {
        case .getCityWeather(let cityId, let appId):
            return ["id": cityId, "appid": appId]
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
