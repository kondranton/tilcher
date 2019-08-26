import UIKit
import Nuke

class UnderlayedTableViewCell: UITableViewCell, ViewReusable {
    var underlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            underlayView.backgroundColor = .backgroundColor
        } else {
            underlayView.backgroundColor = .white
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }

    func setUp() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        addSubview(underlayView)
        underlayView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-4)
        }
    }
}

final class ShopTableViewCell: UnderlayedTableViewCell {
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
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
            make.leading.equalTo(nameLabel.snp.leading)
        }
    }
}
