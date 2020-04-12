import Foundation

extension JSONSerialization {
    public static func jsonObject(data: Data, options: JSONSerialization.ReadingOptions = [.allowFragments], error: NSErrorPointer = nil) -> [String: Any]? {
        var object: [String: Any]?
        do {
            object = try JSONSerialization.jsonObject(with: data, options: options) as? [String: Any]
        } catch let aError as NSError {
            if error != nil {
                error?.pointee = aError
            }
        }
        return object
    }
}
