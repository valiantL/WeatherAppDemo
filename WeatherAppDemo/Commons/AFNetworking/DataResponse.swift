import Alamofire

public extension DataResponse {
    var httpStatusCode: Int {
        if let httpStatusCode = self.response?.statusCode {
            return httpStatusCode
        }
        return -99999
    }

    var jsonDictionary: [String: Any] {
        if let response = self.result.value as? APIManagerResponse {
            return response.json
        }
        return [ : ]
    }

    func networkingErrorOccurred() -> Bool {
        if self.result.error is BackendError, case .network(let backendError) = self.result.error as! BackendError {
            debugPrint("Backend error occurred: \(backendError)")
            return true
        }
        return false
    }
}


