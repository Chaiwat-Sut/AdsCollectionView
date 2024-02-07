import UIKit

// MARK: - Y/N handling

let kYesString = "Y"
let kNoString = "N"

extension String {
    var boolValue: Bool? {
        switch self {
        case "1", "true": return true
        case "0", "false": return false
        default: return nil
        }
    }
    
    var isNotEmpty: Bool {
        return !isEmpty
    }
    
    var isBackSpace: Bool {
        guard let char = self.cString(using: String.Encoding.utf8) else {
            return false
        }
        return strcmp(char, "\\b") == -92
    }
    
    
    func getIndex(from: Int) -> Index {
        if from < count {
            return self.index(startIndex, offsetBy: from)
        } else {
            return self.index(startIndex, offsetBy: count)
        }
    }
    
    func substring(from index: Int) -> String {
        let fromIndex = getIndex(from: index)
        return String(self[fromIndex...])
    }
    
    func substring(to index: Int) -> String {
        let toIndex = getIndex(from: index)
        return String(self[..<toIndex])
    }
    
    func substring(with range: Range<Int>) -> String {
        let startIndex = getIndex(from: range.lowerBound)
        let endIndex = getIndex(from: range.upperBound)
        return String(self[startIndex..<endIndex])
    }

    subscript(safe index: Int) -> Character? {
        guard index >= 0 && index < count else { return nil }
        return self[self.index(startIndex, offsetBy: index)]
    }
    
    subscript<R>(safe range: R) -> String? where R: RangeExpression, R.Bound == Int {
        let range = range.relative(to: Int.min..<Int.max)
        guard
            range.lowerBound >= 0,
            let lowerIndex = index(startIndex, offsetBy: range.lowerBound, limitedBy: endIndex),
            let upperIndex = index(startIndex, offsetBy: range.upperBound, limitedBy: endIndex)
            else {
                return nil
        }
        
        return String(self[lowerIndex..<upperIndex])
    }
    
    func nsRange<T: StringProtocol>(of aString: T) -> NSRange? {
        guard let range = range(of: aString) else { return nil }
        return .init(range, in: self)
    }
    
    static func from(json: Any) -> String {
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: [])
            return String(data: data1, encoding: String.Encoding.utf8) ?? ""
        } catch {
            return ""
        }
    }
    
    var length: Int {
        return count
    }
    
    var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
    
    var deletingPathExtension: String {
        return (self as NSString).deletingPathExtension
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    // https://ktbinnovation.atlassian.net/browse/NN-307943
    // AD Confirm that there can be two types of L10n Replacement. // EX: __riskLevel__ and __RiskLevel__
    func lowerCaseFirstLetter() -> String {
        return prefix(1).lowercased() + dropFirst()
    }
}

// MARK: Default string value

/* Works just like ??, but the default value is always String
 
 Sample usage:
 
 var someValue: Int? = 5
 print("The value is \(someValue ??? "unknown")")
 // → "The value is 5"
 
 someValue = nil
 print("The value is \(someValue ??? "unknown")")
 // → "The value is unknown"
 */

infix operator ???: NilCoalescingPrecedence

public func ??? <T>(optional: T?, defaultValue: @autoclosure () -> String) -> String {
    return optional.map { String(describing: $0) } ?? defaultValue()
}

// MARK: Other Account

public extension String {
    func arabicNumbers() -> String {
        let characterSet = CharacterSet(charactersIn: "0123456789").inverted
        return self.components(separatedBy: characterSet).joined(separator: "")
    }
}

public extension String {
    func string(byStrippingCharactersOtherThan characters: CharacterSet) -> String {
        return String(String.UnicodeScalarView(unicodeScalars.filter { characters.contains($0) }))
    }
    
    func sanitizedProxyID(maxChars: Int = 13) -> String {
        var sanitizedProxyID = string(byStrippingCharactersOtherThan: CharacterSet.decimalDigits)
        if sanitizedProxyID.length > maxChars {
            let maxIndex = sanitizedProxyID.index(sanitizedProxyID.startIndex, offsetBy: maxChars)
            sanitizedProxyID = String(sanitizedProxyID[..<maxIndex])
        }
        
        return sanitizedProxyID
    }
}
