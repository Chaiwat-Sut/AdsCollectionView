extension Optional {
    var isNil: Bool {
        return self == nil
    }
    
    var isNotNil: Bool {
        self != nil
    }
    
    var hasValue: Bool {
        if let stringValue = self as? String {
            return stringValue.isNotEmpty
        } else {
            return !isNil
        }
    }
}

extension Optional where Wrapped: Collection {
    /// !hasValue.
    var isNilOrEmpty: Bool {
        guard let collection = self else { return true }
        return collection.isEmpty
    }
}
