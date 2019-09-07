import Foundation
import Amplitude_iOS

class AnalyticsService {
    private var firstLaunchService: FirstLaunchServiceProtocol

    init(firstLaunchService: FirstLaunchServiceProtocol = FirstLaunchService.shared) {
        self.firstLaunchService = firstLaunchService
    }

    func setupAnalyticsAndStartSession() {
        Amplitude.instance().initializeApiKey(Environment.current.amplitudeKey)

        let didLaunch = firstLaunchService.didLaunch()

        if !didLaunch {
            AnalyticsEvents.Session.firstTime().send()
            firstLaunchService.setDidLaunch()
        }

        AnalyticsEvents.Session.sessionStart().send()
    }
}
