import SnapKit

final class StatItemView: UIView {
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    private var textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryColor
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0

        return label
    }()

    var image: UIImage? {
        get {
            return self.imageView.image
        }
        set {
            self.imageView.image = newValue
        }
    }

    var text: String? {
        get {
            return self.textLabel.text
        }
        set {
            self.textLabel.text = newValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUp() {
        self.addSubview(self.imageView)
        self.addSubview(self.textLabel)

        self.imageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.height.width.equalTo(self.snp.height)
        }

        self.textLabel.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.leading.equalTo(self.imageView.snp.trailing).offset(8)
        }
    }
}
