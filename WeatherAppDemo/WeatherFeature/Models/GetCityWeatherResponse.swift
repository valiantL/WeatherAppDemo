import Foundation

struct GetCityWeatherResponse: CreatableFromJSON {
    let weather: [Weather]?
    let name: String?
    let main: Main?
    
    init(name: String?, main: Main?, weather: [Weather]?) {
        self.name = name
        self.weather = weather
        self.main = main
    }
    
    public init?(json: [String: Any]) {
        let name = json["name"] as? String
        let weather = Weather.createRequiredInstances(from: json, arrayKey: "weather")
        let main = Main(json: json, key: "main")
        self.init(name: name, main: main, weather: weather)
    }
}

struct Weather: CreatableFromJSON {
    let icon: String?
    let description: String?
    
    init(icon: String?, description: String?) {
        self.icon = icon
        self.description = description
    }
    
    public init?(json: [String: Any]) {
        let description = json["description"] as? String
        let icon = json["icon"] as? String
        self.init(icon: icon, description: description)
    }
}

struct Main: CreatableFromJSON {
    let temp: Double
    let humidity: Int?
    
    init(temp: Double, humidity: Int?) {
        self.temp = temp
        self.humidity = humidity
    }
    
    public init?(json: [String: Any]) {
        guard let temp = json["temp"] as? Double else { debugPrint("Expected non-optional property [Double] of type [Decimal] on object [Main] but did not find"); return nil; }
        let humidity = json["humidity"] as? Int
        self.init(temp: temp, humidity: humidity)
    }
}


