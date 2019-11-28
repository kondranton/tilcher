import UIKit
import Nuke

final class RatingTableViewCell: UnderlayedTableViewCell {
    func setUp(with model: ParticipantViewModel) {
        self.nameLabel.text = model.name
        self.positionView.value = model.position

        self.looksView.text = model.looks
        self.publicationsView.text = model.publications
        self.shopsView.text = model.shops

        self.pointsView.points = "\(model.points)"
        self.pointsView.pointsNote = String.localizedStringWithFormat(
            NSLocalizedString("points", comment: ""),
            model.points
        )

        if let url = model.imageURL {
            Nuke.loadImage(with: url, into: self.photoImageView)
        }
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
        label.font = .systemFont(ofSize: 17, weight: .light)
        return label
    }()

    private var looksView: StatItemView = {
        let view = StatItemView()
        view.image = UIImage(named: "look_mini")
        return view
    }()

    private var publicationsView: StatItemView = {
        let view = StatItemView()
        view.image = UIImage(named: "instagram_mini")
        return view
    }()

    private var shopsView: StatItemView = {
        let view = StatItemView()
        view.image = UIImage(named: "shop_mini")
        return view
    }()

    private var pointsView: PointsView = {
        let view = PointsView()
        return view
    }()

    override func setUp() {
        super.setUp()
        let statsStackView = UIStackView(
            arrangedSubviews: [
                self.looksView,
                self.publicationsView,
                self.shopsView
            ]
        )
        statsStackView.spacing = 16

        [
            self.photoImageView,
            self.positionView,
            self.nameLabel,
            statsStackView,
            self.pointsView
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
            make.top.equalTo(photoImageView.snp.top).offset(-2)
//            make.trailing.equalTo(self.pointsView.snp.leading).offset(8)
        }

        statsStackView.snp.makeConstraints { make in
            make.leading.equalTo(self.nameLabel)
            make.height.equalTo(16)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(10)
        }

        self.pointsView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
        }
    }
}
