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

struct EditableUserProfile {
    var name: String
    var instagramUsername: String
    var image: RemoteImage?
}

extension EditableUserProfile {
    init(profile: StylistProfile) {
        self.init(
            name: profile.name,
            instagramUsername: profile.instagramUsername ?? "",
            image: profile.profilePhoto
        )
    }
}
