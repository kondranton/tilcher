import Foundation

struct AnalyticsProperties {
    static func userRole(type: UserRole) -> AnalyticsProperty {
        return AnalyticsProperty(name: "User Type", value: type.rawValue)
    }
}
