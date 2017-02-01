import Foundation

extension NSCoder {

    /// Decode a Swift type that was previously encoded with
    /// `encode(_:)`.
    public func decodeValue<Value: _ObjectiveCBridgeable>(of type: Value.Type = Value.self) -> Value? where Value._ObjectiveCType: NSCoding, Value._ObjectiveCType: NSObject {
        return decodeObject() as? Value
    }

    /// Decode a Swift type that was previously encoded with
    /// `encode(_:forKey:)`.
    public func decodeValue<Value: _ObjectiveCBridgeable>(of type: Value.Type = Value.self, forKey key: String) -> Value? where Value._ObjectiveCType: NSCoding, Value._ObjectiveCType: NSObject {
        return decodeObject(of: Value._ObjectiveCType.self, forKey: key).map(Value._unconditionallyBridgeFromObjectiveC)
    }

    /// Decode a Swift type at the root of a hierarchy that was previously
    /// encoded with `encode(_:)`.
    ///
    /// The top-level distinction is important, as `NSCoder` uses Objective-C
    /// exceptions internally to communicate failure; here they are translated
    /// into Swift error-handling.
    @available(macOS 10.11, iOS 9.0, watchOS 2.0, tvOS 9.0, *)
    public func decodeTopLevelValue<Value: _ObjectiveCBridgeable>(of type: Value.Type = Value.self) throws -> Value? where Value._ObjectiveCType: NSCoding, Value._ObjectiveCType: NSObject {
        return try decodeTopLevelObject() as? Value
    }

    /// Decode a Swift type at the root of a hierarchy that was previously
    /// encoded with `encode(_:forKey:)`.
    ///
    /// The top-level distinction is important, as `NSCoder` uses Objective-C
    /// exceptions internally to communicate failure; here they are translated
    /// into Swift error-handling.
    @available(macOS 10.11, iOS 9.0, watchOS 2.0, tvOS 9.0, *)
    public func decodeTopLevelValue<Value: _ObjectiveCBridgeable>(of type: Value.Type = Value.self, forKey key: String) throws -> Value? where Value._ObjectiveCType: NSCoding, Value._ObjectiveCType: NSObject {
        return try decodeTopLevelObject(of: Value._ObjectiveCType.self, forKey: key).map(Value._unconditionallyBridgeFromObjectiveC)
    }

}

extension NSKeyedUnarchiver {

    /// Decodes and returns the tree of values previously encoded into `data`.
    public static func unarchivedValue<Value: _ObjectiveCBridgeable>(of type: Value.Type = Value.self, with data: Data) -> Value? where Value._ObjectiveCType: NSCoding, Value._ObjectiveCType: NSObject {
        return unarchiveObject(with: data) as? Value
    }

    /// Decodes and returns the tree of values previously encoded into `data`.
    @available(macOS 10.11, iOS 9.0, watchOS 2.0, tvOS 9.0, *)
    public class func unarchivedTopLevelValue<Value: _ObjectiveCBridgeable>(of type: Value.Type = Value.self, with data: Data) throws -> Value? where Value._ObjectiveCType: NSCoding, Value._ObjectiveCType: NSObject {
        return try unarchiveTopLevelObjectWithData(data as NSData) as? Value
    }
}

extension NSKeyedArchiver {

    /// Returns a data object containing the encoded form of the instances whose
    /// root `value` is given.
    public static func archivedData<Value: _ObjectiveCBridgeable>(withRoot value: Value?) -> Data {
        let data = NSMutableData()

        autoreleasepool {
            let archiver = self.init(forWritingWith: data)
            defer { archiver.finishEncoding() }
            archiver.encode(value.map { $0 as Any }, forKey: NSKeyedArchiveRootObjectKey)
        }

        return data as Data
    }

}
