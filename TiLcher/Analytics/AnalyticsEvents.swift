import Foundation

enum AnalyticsEvents {
    enum Session {
        static func firstTime() -> AnalyticsEvent {
            return AnalyticsEvent(
                name: "First Launch",
                parameters: [:]
            )
        }
        static func sessionStart() -> AnalyticsEvent {
            return AnalyticsEvent(
                name: "Session Start",
                parameters: [:]
            )
        }
    }

    enum Auth {
        static let validPhoneEntered = AnalyticsEvent(name: "Valid phone entered")
        static func loginTapped(success: Bool) -> AnalyticsEvent {
            return AnalyticsEvent(
                name: "Login tap",
                parameters: [
                    "Success": success
                ]
            )
        }
        static func nextTapped(success: Bool, screen: AuthScreenType) -> AnalyticsEvent {
            return AnalyticsEvent(
                name: "Next tap",
                parameters: [
                    "Success": success,
                    "Screen": screen.rawValue
                ]
            )
        }
    }

    enum ProfileReview {
        static let open = AnalyticsEvent(name: "Open Profile Review")
        static let activeButtonTap = AnalyticsEvent(name: "Profile Review Active Button Tap")
        static let logout = AnalyticsEvent(name: "Logout")
    }

    enum Profile {
        static let changeName = AnalyticsEvent(name: "Changed Profile Name")
        static let changeInstagram = AnalyticsEvent(name: "Changed Profile Instagram")
        static let changePhoto = AnalyticsEvent(name: "Changed Profile Photo")
    }

    enum Shops {
        static func selectedShop(name: String, score: Int) -> AnalyticsEvent {
            return AnalyticsEvent(
                name: "Selected shop",
                parameters: [
                    "Name": name,
                    "Score": score
                ]
            )
        }
    }

    enum Shop {
        static let instagramTap = AnalyticsEvent(name: "Shop Instagram tap")
        static let acceptedTap = AnalyticsEvent(name: "Shop Accepted")
        static let finishedTap = AnalyticsEvent(name: "Shop Finished")
        static let markerTap = AnalyticsEvent(name: "Shop Marker Tap")
    }

    enum ShopReview {
        static let sent = AnalyticsEvent(name: "Shop Review Sent")
    }
}
