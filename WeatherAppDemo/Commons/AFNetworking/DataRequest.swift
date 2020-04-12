import Alamofire

import Foundation

public extension DataRequest {

    @discardableResult
    func apiManagerResponse(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<APIManagerResponse>) -> Void) -> Self {
        return response(
            queue: queue,
            responseSerializer: DataRequest.apiManagerResponseSerializer(),
            completionHandler: completionHandler
        )
    }

    static func apiManagerResponseSerializer() -> DataResponseSerializer<APIManagerResponse> {
        return DataResponseSerializer { request, response, data, error in


            // Pass through any underlying URLSession error to the .network case.
            guard error == nil else {
                let backendError = BackendError.network(error: error! as NSError)
                return .failure(backendError)
            }

            // Use Alamofire's existing data serializer to extract the data, passing the error as nil, as it has
            // already been handled.
            let result = Request.serializeResponseData(response: response, data: data, error: nil)
            guard case let .success(validData) = result else {
                return .failure(BackendError.dataSerialization(error: result.error! as! AFError))
            }
            
            // check that we can parse the data
            let jsonDictionary = JSONSerialization.jsonObject(data: validData)
            let apiErrors = APIManagerResponseErrors(json: jsonDictionary  ?? [:])
            let apiWarnings = APIManagerResponseWarnings(json: jsonDictionary  ?? [:])
            let responseString = String(data: validData, encoding: .utf8)
            let apiManagerResponse = APIManagerResponse(responseString: responseString, json: jsonDictionary, errors: apiErrors?.errors, warnings: apiWarnings?.warnings)
            return .success(apiManagerResponse)
        }
    }
}
