import SnapKit

final class BadgeView: UIView {
    private var valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textAlignment = .center

        return label
    }()

    var value: String? {
        get {
            return valueLabel.text
        }
        set {
            valueLabel.text = newValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUp() {
        self.backgroundColor = .mainColor

        self.addSubview(self.valueLabel)
        self.valueLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
