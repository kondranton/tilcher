import Foundation

extension Date {
    func days(from date: Date) -> Int {
        let currentCalendar = Calendar.current
        return currentCalendar.dateComponents([.day], from: date, to: self).day ?? 0
    }
}
