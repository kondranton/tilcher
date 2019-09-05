import SnapKit

final class BannerTableViewCell: UITableViewCell, ViewReusable {
    private lazy var bannerView: BannerView = {
        let view = BannerView()
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUp(with model: String) {
        bannerView.text = model
    }

    private func setUp() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        addSubview(bannerView)
        bannerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
    }
}
