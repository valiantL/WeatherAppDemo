import Foundation

public enum ServiceConfigurationError: Error {
    case parsing
    case unknown
}

public enum BackendError: Error {
    case network(error: NSError) // Capture any underlying Error from the URLSession API
    case dataSerialization(error: Error)
    case other
}

public protocol CreatableFromJSON {
    /// Attempts to configure a new instance of the conforming type with values from a JSON dictionary.
    init?(json: [String: Any])
}

extension CreatableFromJSON {
    /// Attempts to configure a new instance using a JSON dictionary selected by the `key` argument.
    public init?(json: [String: Any], key: String) {
        guard let jsonDictionary = json[key] as? [String: Any] else {
            return nil
        }
        self.init(json: jsonDictionary)
    }

    /// Attempts to produce an array of instances of the conforming type based on an array in the JSON dictionary.
    /// - Returns: `nil` if the JSON array is missing or if there is an invalid/null element in the JSON array.
    public static func createRequiredInstances(from json: [String: Any], arrayKey: String) -> [Self]? {
        guard let jsonDictionaries = json[arrayKey] as? [[String: Any]] else {
            return nil
        }
        var array = [Self]()
        for jsonDictionary in jsonDictionaries {
            guard let instance = Self(json: jsonDictionary) else {
                return nil
            }
            array.append(instance)
        }
        return array
    }

    static func createOptionalInstances(from json: [String: Any], arrayKey: String) -> [Self?]? {
        guard let array = json[arrayKey] as? [Any] else {
            return nil
        }
        return array.map { item in
            if let jsonDictionary = item as? [String: Any] {
                return Self(json: jsonDictionary)
            } else {
                return nil
            }
        }
    }
}
