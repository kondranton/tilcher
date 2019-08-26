import SnapKit

final class SwitchView: UIControl {
    private(set) var isRightSelected = false {
        didSet {
            rightOptionView.isOn = isRightSelected
            leftOptionView.isOn = !isRightSelected
        }
    }

    // TODO: - Make namings customizable
    private var leftOptionView: CheckboxView = {
        let view = CheckboxView()
        view.isOn = true
        view.title = "ДА"
        return view
    }()

    private var rightOptionView: CheckboxView = {
        let view = CheckboxView()
        view.isOn = false
        view.title = "НЕТ"
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUp() {
        let stackView = UIStackView(
            arrangedSubviews: [
                leftOptionView,
                rightOptionView
            ]
        )
        stackView.spacing = 0
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.isUserInteractionEnabled = false

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        guard let touchLocation = touch?.location(in: self) else {
            super.endTracking(touch, with: event)
            return
        }

        if leftOptionView.frame.contains(touchLocation) {
            isRightSelected = false
        } else if rightOptionView.frame.contains(touchLocation) {
            isRightSelected = true
        }

        sendActions(for: [.valueChanged])

        super.endTracking(touch, with: event)
    }
}
