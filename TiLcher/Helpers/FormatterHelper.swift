import Foundation

class FormatterHelper {
    private init() { }

    static func string(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }

    static func serverValue(from date: Date) -> Int {
        return Int(date.timeIntervalSince1970)
    }
}
