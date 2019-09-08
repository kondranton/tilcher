import UIKit
import Nuke

final class ShopAssignmentTableViewCell: UnderlayedTableViewCell {
    func setUp(with model: ShopItemViewModel) {
        nameLabel.text = model.name
        typeLabel.text = model.type
        pointsLabel.text = model.pointsForLook

        if let url = model.imageUrl {
            Nuke.loadImage(with: url, into: photoImageView)
        }
    }

    private var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 23
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .backgroundColor
        return imageView
    }()

    private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()

    private var typeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.numberOfLines = 2
        return label
    }()

    private var pointsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .center
        label.backgroundColor = .mainColor
        label.layer.cornerRadius = 11
        label.layer.masksToBounds = true
        return label
    }()

    private var pointsNoteLabel: UILabel = {
        let label = UILabel()
        label.text = "баллов за лук"
        label.font = .systemFont(ofSize: 10, weight: .regular)
        return label
    }()

    override func setUp() {
        super.setUp()

        [
            photoImageView,
            nameLabel,
            typeLabel,
            pointsLabel,
            pointsNoteLabel
        ]
        .forEach(underlayView.addSubview)

        photoImageView.snp.makeConstraints { make in
            make.height.equalTo(46)
            make.width.equalTo(46)
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }

        pointsLabel.snp.makeConstraints { make in
            make.width.equalTo(72)
            make.height.equalTo(22)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(photoImageView)
        }

        pointsNoteLabel.snp.makeConstraints { make in
            make.centerX.equalTo(pointsLabel.snp.centerX)
            make.top.equalTo(pointsLabel.snp.bottom).offset(2)
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(photoImageView.snp.trailing).offset(16)
            make.top.equalTo(photoImageView.snp.top)
        }

        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.leading.equalTo(nameLabel.snp.leading)
            make.trailing.equalTo(pointsLabel.snp.leading).offset(-8)
        }
    }
}
