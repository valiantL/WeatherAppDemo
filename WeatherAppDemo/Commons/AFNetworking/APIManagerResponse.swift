import Foundation

public struct APIManagerResponse {
    var responseString: String?
    var json: [String: Any]
    var errors: [APIError]?
    var warnings: [APIWarning]?

    public init(responseString: String?, json: [String: Any]?, errors: [APIError]?, warnings: [APIWarning]?) {
        self.responseString = responseString
        self.json = json ?? [:]
        self.errors = errors
        self.warnings = warnings
    }
}
