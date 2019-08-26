import Foundation

class AnalyticsProperty: AnalyticsReportable {
    func send() {
        AnalyticsReporter.setUserProperty(name, value: value)
    }

    var name: String
    var value: Any

    init(name: String, value: Any) {
        self.name = name
        self.value = value
    }
}
