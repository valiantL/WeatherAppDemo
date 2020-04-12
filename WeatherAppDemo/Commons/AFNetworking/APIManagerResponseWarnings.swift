import Foundation

public struct APIWarning: CreatableFromJSON {
    let code: String
    let message: String
    init(code: String, message: String) {
        self.code = code
        self.message = message
    }

    public init?(json: [String: Any]) {
        guard let code = json["code"] as? String else { return nil }
        guard let message = json["message"] as? String else { return nil }
        self.init(code: code, message: message)
    }
}

struct APIManagerResponseWarnings: CreatableFromJSON {
    let warnings: [APIWarning]
    init(warnings: [APIWarning]) {
        self.warnings = warnings
    }

    init?(json: [String: Any]) {
        guard let warnings = APIWarning.createRequiredInstances(from: json, arrayKey: "warnings") else { return nil }
        self.init(warnings: warnings)
    }
}
