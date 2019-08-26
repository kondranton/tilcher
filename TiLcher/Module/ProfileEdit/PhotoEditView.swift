import SnapKit
import Nuke

final class PhotoEditView: UIView {
    var onTouch: (() -> Void)?

    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .green
        return imageView
    }()

    private var editLabel: UILabel = {
        let label = UILabel()
        label.text = "Поменять"
        label.textColor = .white
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textAlignment = .center

        return label
    }()

    func load(from url: URL) {
        Nuke.loadImage(with: url, into: imageView)
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUp() {
        layer.cornerRadius = 67.5
        layer.masksToBounds = true

        let editUnderlayView = UIView()
        editUnderlayView.backgroundColor = .blackSemitransparentColor

        [
            imageView,
            editUnderlayView
        ]
        .forEach(addSubview)

        editUnderlayView.addSubview(editLabel)

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        editUnderlayView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(32)
        }

        editLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        onTouch?()
    }
}
