struct NewUserProfile {
    var name: String
    var type: UserRole
    var instagramUsername: String
}

extension NewUserProfile {
    init() {
        self.init(name: "", type: .stylist, instagramUsername: "")
    }

    init(profile: StylistProfile) {
        self.init(
            name: profile.name,
            type: .stylist,
            instagramUsername: profile.instagramUsername ?? ""
        )
    }
}
