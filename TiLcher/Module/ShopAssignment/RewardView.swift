import UIKit
import SnapKit

final class RewardView: UIView {
    private var numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center

        return label
    }()

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.textAlignment = .center

        return label
    }()

    var number: String? {
        get {
            return numberLabel.text
        }
        set {
            numberLabel.text = newValue
        }
    }

    var title: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }

    init() {
        super.init(frame: .zero)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUp() {
        let stackView = UIStackView(
            arrangedSubviews: [
                numberLabel,
                titleLabel
            ]
        )
        stackView.axis = .vertical
        stackView.spacing = 4

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
