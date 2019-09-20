import SnapKit

final class BillPhotoTableViewCell: UITableViewCell, ViewReusable {
    private var billPhotoView: BillPhotoEditView = {
        let photoView = BillPhotoEditView()
        return photoView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }

    func setUp(with model: UIImage?) {
        billPhotoView.imageView.image = model
    }

    private func setUp() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        addSubview(billPhotoView)

        billPhotoView.snp.makeConstraints { make in
            make.width.equalTo(130)
            make.height.equalTo(130)
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
}
