import SnapKit

final class ResultsTableViewCell: HeaderedTableViewCell {
    let looksView: ResultInputView = {
        let view = ResultInputView()
        view.placeholder = "Луки"
        return view
    }()

    let collagesView: ResultInputView = {
        let view = ResultInputView()
        view.placeholder = "Коллажи"
        return view
    }()

    let storiesView: ResultInputView = {
        let view = ResultInputView()
        view.placeholder = "Сторис"
        return view
    }()

    let postsView: ResultInputView = {
        let view = ResultInputView()
        view.placeholder = "Посты"
        return view
    }()

    override func setUp() {
        super.setUp()
        headerLabel.text = "Введи данные для рейтинга"

        let topStackView = UIStackView(
            arrangedSubviews: [
                looksView,
                collagesView
            ]
        )
        topStackView.axis = .horizontal
        topStackView.spacing = 8
        topStackView.distribution = .fillEqually

        let bottomStackView = UIStackView(
            arrangedSubviews: [
                storiesView,
                postsView
            ]
        )
        bottomStackView.axis = .horizontal
        bottomStackView.spacing = 8
        bottomStackView.distribution = .fillEqually

        let verticalStackView = UIStackView(
            arrangedSubviews: [
                topStackView,
                bottomStackView
            ]
        )
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fillEqually
        verticalStackView.spacing = 8

        contentView.addSubview(verticalStackView)
        verticalStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalTo(headerLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-4)
            make.height.equalTo(74 * 2 + 8)
        }
    }
}
