struct RankedStylist: Codable {
    let id: Int
    let name: String
    let instagramUsername: String?
    var profilePhoto: RemoteImage?
    let pointsData: StylistProfile.Statistics?
}
