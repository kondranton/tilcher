import SnapKit

final class EditPhotoTableViewCell: UITableViewCell, ViewReusable {
    let photoView: PhotoEditView = {
        let view = PhotoEditView()
        return view
    }()

    func setUp(with url: String, takePhoto: @escaping () -> Void) {
        if let url = URL(string: url) {
            photoView.load(from: url)
        }
        photoView.onTouch = takePhoto
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUp() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(photoView)
        photoView.snp.makeConstraints { make in
            make.height.equalTo(135)
            make.width.equalTo(135)
            make.bottom.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
    }
}
