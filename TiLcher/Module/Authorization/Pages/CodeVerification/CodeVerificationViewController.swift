import UIKit
import InputMask

final class CodeVerificationViewController: UIViewController {
    private static let resendTimeout: Double = 60

    var verificationPackage: AuthVerificationPackage?

    private var code: String = ""

    private let authorizationService = AuthorizationService()
    private var onEditingChange: EditingChangeHandler
    private var onNext: (AuthorizationService.AuthResult) -> Void
    private var onBack: () -> Void
    private var onError: (String) -> Void
    private var resendTimer: Timer?
    private var lastRestartDate: Date?

    private lazy var codeListener: MaskedTextFieldDelegate = {
        let codeListener = MaskedTextFieldDelegate(primaryFormat: "[0000]")
        codeListener.listener = self

        return codeListener
    }()

    private lazy var verificationView: CodeVerificationView = {
        CodeVerificationView(
            onEditingChange: { [weak self] isEditing in
                self?.onEditingChange(isEditing)
            },
            onNextTap: { [weak self] in
                self?.verifyCode()
            },
            onBackTap: { [weak self] in
                self?.onBack()
            },
            onResendTap: { [weak self] in
                self?.resendCode()
            }
        )
    }()

    init(
        onEditingChange: @escaping EditingChangeHandler,
        onNext: @escaping (AuthorizationService.AuthResult) -> Void,
        onBack: @escaping () -> Void,
        onError: @escaping (String) -> Void
    ) {
        self.onEditingChange = onEditingChange
        self.onNext = onNext
        self.onBack = onBack
        self.onError = onError
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let view = UIView()

        view.addSubview(verificationView)
        verificationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        verificationView.textField.delegate = codeListener
        verificationView.textField.keyboardType = .numberPad

        self.view = view
    }

    func verifyCode() {
        guard let package = verificationPackage else {
            fatalError("Should be set")
        }

        authorizationService.verify(
            code: code,
            verificationPackage: package
        )
        .done { authResult in
            self.onNext(authResult)
            AnalyticsEvents.Auth.nextTapped(success: true, screen: .code).send()
        }
        .catch { error in
            AnalyticsEvents.Auth.nextTapped(success: false, screen: .code).send()
            if let error = error as? APIError {
                if error.code == "invalid_code" {
                    self.onError("Неверный код")
                } else {
                    self.onError(error.message)
                }
            } else {
                assertionFailure(error.localizedDescription)
            }
        }
    }

    private func resendCode() {
        guard let verificationPackage = verificationPackage else {
            fatalError("Set verification package before calling this method")
        }

        authorizationService
            .requestCode(to: verificationPackage.phone)
            .done { [weak self] verificationPackage in
                self?.verificationPackage = verificationPackage
                self?.restartTimer()
            }
            .cauterize()
    }

    private func restartTimer() {
        lastRestartDate = Date()
        resendTimer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true
        ) { [weak self] _ in
            self?.updateTimeoutLabel()
        }
        updateTimeoutLabel()
        verificationView.state = .waitForResend
    }

    func updateTimeoutLabel() {
        func reset() {
            resendTimer?.invalidate()
            verificationView.state = .resendCode
        }

        guard
            resendTimer != nil,
            let lastRestartDate = lastRestartDate
        else {
            reset()
            return
        }

        let secondsPassed = Date().timeIntervalSince(lastRestartDate)

        if secondsPassed > CodeVerificationViewController.resendTimeout {
            reset()
        } else {
            let secondsLeft = CodeVerificationViewController.resendTimeout - secondsPassed
            verificationView.resendNoticeText = """
            Следующее смс можно будет отправить через \(Int(secondsLeft)) сек.
            """
        }
    }
}

extension CodeVerificationViewController: MaskedTextFieldDelegateListener {
    func textField(
        _ textField: UITextField,
        didFillMandatoryCharacters complete: Bool,
        didExtractValue value: String
    ) {
        code = value
        verificationView.isNextEnabled = complete
    }
}
