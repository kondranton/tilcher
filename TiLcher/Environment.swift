import Foundation

struct Environment {
    let baseURL: String
    let amplitudeKey: String
    let shouldSendSMS: Bool
}

extension Environment {
    static let current: Environment = .test()
}

extension Environment {
    private static func production() -> Environment {
        return Environment(
            baseURL: "https://tilcher-production.herokuapp.com/api/v1/",
            amplitudeKey: "d429dcbf292e16946cc54a239bcbde56",
            shouldSendSMS: true
        )
    }

    /// Use for testing before uploading to production
    private static func productionNoAnalytics() -> Environment {
        return Environment(
            baseURL: "https://tilcher-production.herokuapp.com/api/v1/",
            amplitudeKey: "c468c2d131ee20069397b8521ec40c15",
            shouldSendSMS: true
        )
    }

    private static func test() -> Environment {
        return Environment(
            baseURL: "https://tilcher-stage.herokuapp.com/api/v1/",
            amplitudeKey: "c468c2d131ee20069397b8521ec40c15",
            shouldSendSMS: false
        )
    }
}
