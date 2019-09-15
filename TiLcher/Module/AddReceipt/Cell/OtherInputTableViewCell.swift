import SnapKit

struct OtherInputViewModel {
    let textRepresentationValue: String?
    let placeholder: String
    let hasChevron: Bool
}

final class OtherInputTableViewCell: UnderlayedTableViewCell {
    private var chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "chevron")
        return imageView
    }()

    private var placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .subtitleColor
        label.font = .systemFont(ofSize: 16, weight: .bold)

        return label
    }()

    private var valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .bold)

        return label
    }()

    func setUp(with model: OtherInputViewModel) {
        valueLabel.text = model.textRepresentationValue
        placeholderLabel.text = model.placeholder
        chevronImageView.isHidden = !model.hasChevron

        if model.textRepresentationValue == nil {
            valueLabel.snp.remakeConstraints { make in
                make.leading.equalToSuperview().offset(16)
                make.centerY.equalToSuperview()
                make.trailing.equalTo(chevronImageView.snp.leading).offset(-8)
            }
            placeholderLabel.snp.remakeConstraints { make in
                make.leading.equalToSuperview().offset(16)
                make.centerY.equalToSuperview()
                make.trailing.equalTo(chevronImageView.snp.leading).offset(-8)
            }
            placeholderLabel.font = placeholderLabel.font.withSize(17)
        } else {
            valueLabel.snp.remakeConstraints { make in
                make.leading.equalToSuperview().offset(16)
                make.centerY.equalToSuperview().offset(8)
                make.trailing.equalTo(chevronImageView.snp.leading).offset(-8)
            }
            placeholderLabel.snp.remakeConstraints { make in
                make.leading.equalToSuperview().offset(16)
                make.trailing.equalTo(chevronImageView.snp.leading).offset(-8)
                make.bottom.equalTo(valueLabel.snp.top).offset(-2)
            }
            placeholderLabel.font = placeholderLabel.font.withSize(12)
        }
    }

    override func setUp() {
        super.setUp()

        [
            placeholderLabel,
            valueLabel,
            chevronImageView
        ]
        .forEach(underlayView.addSubview)

        chevronImageView.snp.makeConstraints { make in
            make.width.equalTo(13)
            make.height.equalTo(24)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(16)
        }
    }
}
