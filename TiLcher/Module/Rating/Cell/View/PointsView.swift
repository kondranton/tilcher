import SnapKit

final class PointsView: UIView {
    private var pointsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .right

        return label
    }()

    private var pointsNoteLabel: UILabel = {
        let label = UILabel()
        label.textColor = .subtitleColor
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 0

        return label
    }()

    var points: String? {
        get {
            return self.pointsLabel.text
        }
        set {
            self.pointsLabel.text = newValue
        }
    }

    var pointsNote: String? {
        get {
            return self.pointsNoteLabel.text
        }
        set {
            self.pointsNoteLabel.text = newValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUp() {
        self.addSubview(self.pointsLabel)
        self.addSubview(self.pointsNoteLabel)

        self.pointsLabel.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }

        self.pointsNoteLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.pointsLabel.snp.bottom)
        }
    }
}
