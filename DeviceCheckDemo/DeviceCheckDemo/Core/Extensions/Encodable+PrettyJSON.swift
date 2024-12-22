import Foundation

extension Encodable {
    
    /// Pretty formatted JSON string representation with sorted keys.
    /// > Note: In case the object can not be encoded successfully, 'nil' will be returned.
    var prettyFormattedJSONString: String? {
        try? data.prettyFormattedJSONString
    }
    
}
