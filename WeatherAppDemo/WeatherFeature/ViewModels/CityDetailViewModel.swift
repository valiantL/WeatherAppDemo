import Foundation
import Alamofire
import AlamofireActivityLogger

class CityDetailViewModel {
    
    func loadCityData(cityId: Int, completion: @escaping (( _: Error?, _: GetCityWeatherResponse?) -> Void)) {
        let hashKeyStr: String! = ServiceConfiguration.getAPIHash()
        print("demo1 hashKeyStr: \(hashKeyStr)")
        let url = GetCityWeatherRouter.getCityWeather(cityId: cityId, appId: hashKeyStr)
        ServiceConfiguration.sessionManager.request(url)
            .log()
            .validate(statusCode: 200 ..< 300)
            .apiManagerResponse { response in
                switch response.httpStatusCode {
                case 200 ..< 300:
                    guard let result = GetCityWeatherResponse(json: response.jsonDictionary) else {
                        completion(ServiceConfigurationError.parsing, nil)
                        return
                    }
                    completion(nil, result)
                default:
                   completion(BackendError.other, nil)
                }
        }
    }
    
    func loadWeatherIcon(codeStr: String) throws -> URL {
        return try GetCityWeatherRouter.getWeatherIcon(codeStr).getWeatherIconURLPath()
    }
}
