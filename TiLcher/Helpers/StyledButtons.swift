import UIKit

enum StyledButtons {
    static func action() -> UIButton {
        let button = UIButton()
        button.backgroundColor = .mainColor
        button.layer.cornerRadius = 24
        button.layer.masksToBounds = true

        return button
    }
}
