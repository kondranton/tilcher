import Foundation
import Amplitude_iOS

class AnalyticsReporter {
    static func reportEvent(_ event: String, parameters: [String: Any] = [:]) {
        Amplitude.instance().logEvent(event, withEventProperties: parameters)
        #if DEBUG
        print("Logging amplitude event \(event), parameters: \(String(describing: parameters))")
        #endif
    }

    static func setUserProperty(_ name: String, value: Any) {
        Amplitude.instance()?.setUserProperties([name: value], replace: true)
        #if DEBUG
        print("Set user property \(name), value: \(String(describing: value))")
        #endif
    }
}
