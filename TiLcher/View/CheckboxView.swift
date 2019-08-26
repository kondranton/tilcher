import SnapKit

final class CheckboxView: UIView {
    var isOn = false {
        didSet {
            checkmarkImageView.isHidden = !isOn
            circleView.backgroundColor = isOn ? .mainColor : .backgroundColor
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

    private var circleView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundColor
        view.layer.cornerRadius = 19
        view.layer.masksToBounds = true
        return view
    }()

    private var checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "checkmark")
        return imageView
    }()

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUp() {
        [
            circleView,
            checkmarkImageView,
            titleLabel
        ]
        .forEach(addSubview)

        circleView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(38)
            make.width.equalTo(38)
        }

        checkmarkImageView.snp.makeConstraints { make in
            make.edges.equalTo(circleView)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(circleView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(circleView.snp.centerY)
        }
    }
}
