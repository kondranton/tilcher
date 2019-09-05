import UIKit
import InputMask

final class CodeRequestViewController: UIViewController {
    let authorizationService = AuthorizationService()

    var onEditingChange: EditingChangeHandler
    var onBecomeStylistTap: (URL) -> Void
    var sentCode: (AuthVerificationPackage) -> Void
    var onError: (String) -> Void

    private var phone: String = ""

    private lazy var phoneListener: MaskedTextFieldDelegate = {
        let phoneListener = MaskedTextFieldDelegate(primaryFormat: "+7 ([000]) [000]-[00]-[00]")
        phoneListener.listener = self

        return phoneListener
    }()

    lazy var authView: CodeRequestView = {
        CodeRequestView(
            onEditingChange: { [weak self] isEditing in
                self?.onEditingChange(isEditing)
            },
            onLoginTap: { [weak self] in
                self?.logIn()
            },
            onBecomeStylistTap: { [weak self] in
                guard let url = URL(string: "https://tilcher.ru/terms") else {
                    return
                }
                self?.onBecomeStylistTap(url)
            }
        )
    }()

    init(
        onEditingChange: @escaping EditingChangeHandler,
        onBecomeStylistTap: @escaping (URL) -> Void,
        sentCode: @escaping (AuthVerificationPackage) -> Void,
        onError: @escaping (String) -> Void
    ) {
        self.onEditingChange = onEditingChange
        self.onBecomeStylistTap = onBecomeStylistTap
        self.sentCode = sentCode
        self.onError = onError
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let view = UIView()

        view.addSubview(authView)
        authView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        authView.textField.delegate = phoneListener

        self.view = view
    }

    func logIn() {
        authView.isLoginEnabled = false
        authorizationService
            .requestCode(to: phone)
            .done(on: .main) { verifier in
                self.sentCode(verifier)
                AnalyticsEvents.Auth.loginTapped(success: true).send()
            }
            .catch { error in
                AnalyticsEvents.Auth.loginTapped(success: false).send()
                if let error = error as? APIError {
                    if error.code == "invalid" {
                        self.onError("Такого номера телефона не существует")
                    } else {
                        self.onError(error.message)
                    }
                } else {
                    assertionFailure(error.localizedDescription)
                }
            }
            .finally {
                self.authView.isLoginEnabled = true
            }
    }
}

extension CodeRequestViewController: MaskedTextFieldDelegateListener {
    func textField(
        _ textField: UITextField,
        didFillMandatoryCharacters complete: Bool,
        didExtractValue value: String
    ) {
        phone = "+7" + value
        authView.isLoginEnabled = complete

        if complete {
            AnalyticsEvents.Auth.validPhoneEntered.send()
        }
    }
}
