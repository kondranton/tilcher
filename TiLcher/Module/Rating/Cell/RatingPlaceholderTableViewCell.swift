import UIKit
import Nuke

final class RatingPlaceholderTableViewCell: UnderlayedTableViewCell {
    func setUp(with model: String) {
        self.positionView.value = model
    }

    private var positionView: BadgeView = {
        let view = BadgeView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()

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
        label.text = "Для получения приза необходимо опубликовать луки минимум из 5 магазинов"
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.numberOfLines = 0
        label.textColor = .subtitleColor
        return label
    }()

    override func setUp() {
        super.setUp()
        [
            self.photoImageView,
            self.positionView,
            self.nameLabel
        ]
        .forEach(self.underlayView.addSubview)

        self.photoImageView.snp.makeConstraints { make in
            make.height.equalTo(46)
            make.width.equalTo(46)
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }

        self.positionView.snp.makeConstraints { make in
            make.leading.top.equalTo(self.photoImageView).inset(-4)
            make.width.height.equalTo(18)
        }

        self.nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(photoImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.bottom.equalTo(photoImageView).offset(-2)
        }
    }
}
