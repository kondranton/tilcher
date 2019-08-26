import UIKit
import SnapKit

final class AnimatedPlaceholderTextField: UITextField {
    lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.isUserInteractionEnabled = false
        return label
    }()

    var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    var color: UIColor {
        set {
            placeholderLabel.textColor = newValue
            lineView.backgroundColor = newValue
            textColor = newValue
        }
        get {
            return placeholderLabel.textColor
        }
    }

    override var text: String? {
        get {
            return super.text
        }
        set {
            if let text = newValue {
                animatePlaceholder(shrink: !text.isEmpty)
            } else {
                animatePlaceholder(shrink: false)
            }
            super.text = newValue
        }
    }

    override var placeholder: String? {
        get {
            return placeholderLabel.text
        }
        set {
            placeholderLabel.text = newValue
        }
    }

    var isPlaceholderSharnk = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }

    func setUp() {
        addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().offset(6)
            make.height.equalTo(2)
        }
    }

    override func becomeFirstResponder() -> Bool {
        animatePlaceholder(shrink: true)
        return super.becomeFirstResponder()
    }

    override func resignFirstResponder() -> Bool {
        if let text = text, text.isEmpty {
            animatePlaceholder(shrink: false)
        }
        return super.resignFirstResponder()
    }

    private func animatePlaceholder(shrink: Bool) {
        guard isPlaceholderSharnk != shrink else {
            return
        }
        self.isPlaceholderSharnk = shrink

        UIView.animate(withDuration: 0.05) {
            if shrink {
                let translation = CGAffineTransform(translationX: 0, y: -20)
                let scale = CGAffineTransform(translationX: 0.75, y: 0.75)
                self.placeholderLabel.transform = translation.concatenating(scale)
                self.placeholderLabel.font = self.placeholderLabel.font.withSize(12)
            } else {
                self.placeholderLabel.transform = .identity
                self.placeholderLabel.font = self.placeholderLabel.font.withSize(16)
            }
        }
    }
}
