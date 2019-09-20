import SnapKit

class AddBillPhotoTableViewCell: UnderlayedTableViewCell {
    private var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "add_bill")
        return imageView
    }()

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Добавить фото чека"
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .bold)

        return label
    }()

    override func setUp() {
        super.setUp()
        [
            iconImageView,
            titleLabel
        ]
        .forEach(underlayView.addSubview)

        iconImageView.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.width.equalTo(36)
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
        }
    }
}
