enum AuthScreenType: String {
    case code,
    name,
    userType = "user_type",
    instagram

    init?(state: AuthorizationViewController.State) {
        switch state {
        case .requestCode:
            return nil
        case .verifyCode:
            self = .code
        case .name:
            self = .name
        case .userType:
            self = .userType
        case .instagram:
            self = .instagram
        }
    }
}
