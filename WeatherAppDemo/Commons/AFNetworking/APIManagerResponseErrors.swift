import Foundation

public struct APIError: CreatableFromJSON {
    let code: String
    let context: String
    let message: String
    let type: String?
    init(code: String, context: String, message: String, type: String?) {
        self.code = code
        self.context = context
        self.message = message
        self.type = type
    }

    public init?(json: [String: Any]) {
        guard let code = json["code"] as? String else { return nil }
        guard let context = json["context"] as? String else { return nil }
        guard let message = json["message"] as? String else { return nil }
        let type = json["type"] as? String
        self.init(code: code, context: context, message: message, type: type)
    }
}

struct APIManagerResponseErrors: CreatableFromJSON {
    let errors: [APIError]
    init(errors: [APIError]) {
        self.errors = errors
    }

    init?(json: [String: Any]) {
        guard let errors = APIError.createRequiredInstances(from: json, arrayKey: "errors") else { return nil }
        self.init(errors: errors)
    }
}
