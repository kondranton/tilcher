import SnapKit

final class ReviewTableViewCell: HeaderedTableViewCell {
    var textView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        return textView
    }()

    override func setUp() {
        super.setUp()
        headerLabel.text = "Твой отзыв о магазине"
        selectionStyle = .none

        let underlayView = UIView()
        underlayView.backgroundColor = .white
        underlayView.layer.cornerRadius = 8
        underlayView.layer.masksToBounds = true

        contentView.addSubview(underlayView)

        underlayView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(headerLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
            make.height.equalTo(88)
        }

        underlayView.addSubview(textView)

        textView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
    }
}

