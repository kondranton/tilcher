import SnapKit

final class BannerView: UIView {
    private var textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryColor
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0

        return label
    }()

    var text: String? {
        get {
            return textLabel.text
        }
        set {
            textLabel.text = newValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUp() {
        backgroundColor = .infoGrayColor
        layer.cornerRadius = 8
        layer.masksToBounds = true

        addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
}
