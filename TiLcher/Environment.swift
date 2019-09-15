import Foundation

struct Environment {
    let baseURL: String
    let amplitudeKey: String
    let shouldSendSMS: Bool
    let logoutOnStart: Bool
}

extension Environment {
    static let current: Environment = .test(logoutOnStart: true)
}

extension Environment {
    private static func production(logoutOnStart: Bool) -> Environment {
        return Environment(
            baseURL: "https://tilcher-production.herokuapp.com/api/v1/",
            amplitudeKey: "d429dcbf292e16946cc54a239bcbde56",
            shouldSendSMS: true,
            logoutOnStart: logoutOnStart
        )
    }

    /// Use for testing before uploading to production
    private static func productionNoAnalytics(logoutOnStart: Bool) -> Environment {
        return Environment(
            baseURL: "https://tilcher-production.herokuapp.com/api/v1/",
            amplitudeKey: "c468c2d131ee20069397b8521ec40c15",
            shouldSendSMS: true,
            logoutOnStart: logoutOnStart
        )
    }

    private static func test(logoutOnStart: Bool) -> Environment {
        return Environment(
            baseURL: "https://tilcher-stage.herokuapp.com/api/v1/",
            amplitudeKey: "c468c2d131ee20069397b8521ec40c15",
            shouldSendSMS: false,
            logoutOnStart: logoutOnStart
        )
    }
}
