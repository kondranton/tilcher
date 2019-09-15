import SnapKit
import Nuke

final class ReceiptTableViewCell: UnderlayedTableViewCell {
    func setUp(with model: ReceiptViewModel) {
        priceLabel.text = model.price
        shopLabel.text = model.shop
        dateLabel.text = model.date
        comissionLabel.text = model.commissionAbsolute
        comissionNoteLabel.text = model.commissionRelative
        if let url = model.photoURL {
            Nuke.loadImage(with: url, into: photoImageView)
        }
    }

    private var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .backgroundColor
        imageView.layer.cornerRadius = 4
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "5000р"
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .bold)

        return label
    }()

    private var shopLabel: UILabel = {
        let label = UILabel()
        label.text = "Zara"
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .regular)

        return label
    }()

    private var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "05.06.2019"
        label.textColor = .subtitleColor
        label.font = .systemFont(ofSize: 14, weight: .regular)

        return label
    }()

    private var comissionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.text = "500р"
        label.textAlignment = .center
        label.backgroundColor = .mainColor
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        return label
    }()

    private var comissionNoteLabel: UILabel = {
        let label = UILabel()
        label.text = "комиссия (10%)"
        label.textColor = .black
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .center

        return label
    }()

    override func setUp() {
        super.setUp()
        [
            photoImageView,
            priceLabel,
            shopLabel,
            dateLabel,
            comissionLabel,
            comissionNoteLabel
        ]
        .forEach(underlayView.addSubview)

        photoImageView.snp.makeConstraints { make in
            make.width.equalTo(68)
            make.height.equalTo(68)
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }

        comissionLabel.snp.makeConstraints { make in
            make.top.equalTo(photoImageView.snp.top).offset(14)
            make.height.equalTo(24)
            make.width.equalTo(80)
            make.trailing.equalToSuperview().offset(-16)
        }

        comissionNoteLabel.snp.makeConstraints { make in
            make.top.equalTo(comissionLabel.snp.bottom).offset(8)
            make.centerX.equalTo(comissionLabel)
        }

        priceLabel.snp.makeConstraints { make in
            make.leading.equalTo(photoImageView.snp.trailing).offset(8)
            make.top.equalTo(photoImageView)
            make.trailing.equalTo(comissionLabel.snp.leading).offset(-8)
        }

        shopLabel.snp.makeConstraints { make in
            make.leading.equalTo(photoImageView.snp.trailing).offset(8)
            make.top.equalTo(priceLabel.snp.bottom).offset(4)
            make.trailing.equalTo(comissionLabel.snp.leading).offset(-8)
        }

        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(photoImageView.snp.trailing).offset(8)
            make.top.equalTo(shopLabel.snp.bottom).offset(4)
            make.trailing.equalTo(comissionLabel.snp.leading).offset(-8)
        }
    }
}
