import SnapKit
import Nuke

final class SelectableShopTableViewCell: UnderlayedTableViewCell {
    private var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 22.5
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .backgroundColor
        return imageView
    }()

    private var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .bold)

        return label
    }()

    private var checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "checkmark")
        return imageView
    }()

    override func setUp() {
        super.setUp()

        [
            photoImageView,
            nameLabel,
            checkmarkImageView
        ]
        .forEach(underlayView.addSubview)

        photoImageView.snp.makeConstraints { make in
            make.width.equalTo(45)
            make.height.equalTo(45)
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(photoImageView.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(checkmarkImageView.snp.leading).offset(-8)
        }

        checkmarkImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.equalTo(36)
            make.height.equalTo(36)
        }
    }

    func setUp(with model: ShopViewModel) {
        nameLabel.text = model.name
        checkmarkImageView.isHidden = !model.isSelected

        if let url = model.imageURL {
            Nuke.loadImage(with: url, into: photoImageView)
        }
    }
}
