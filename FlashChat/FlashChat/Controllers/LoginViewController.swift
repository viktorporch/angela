//
//  LoginViewController.swift
//  FlashChat
//
//  Created by Victor on 22.12.2023.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: LoginViewModelProtocol!
    
    private let emailTextFieldBackground: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.Images.textFieldImage
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let passwordTextFieldBackground: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.Images.textFieldImage
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = Constants.Colors.brandBlue
        textField.textAlignment = .center
        textField.keyboardType = .emailAddress
        textField.font = .systemFont(ofSize: 25)
        textField.autocapitalizationType = .none
        textField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        return textField
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = Constants.Colors.brandBlue
        textField.textAlignment = .center
        textField.isSecureTextEntry = true
        textField.font = .systemFont(ofSize: 25)
        textField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        return textField
    }()
    
    private lazy var LoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 25)
        button.addTarget(self, action: #selector(didTapRegisterButton(_:)), for: .touchUpInside)
        return button
    }()
    
    init(viewModel: LoginViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        setupViews()
        setupBinders()
    }
}
// MARK: - Methods
extension LoginViewController {
    private func setupViews() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.backgroundColor = Constants.Colors.brandBlue
        
        view.addSubview(emailTextFieldBackground)
        emailTextFieldBackground.snp.makeConstraints { make in
            make.width.equalTo(safeArea).multipliedBy(0.85)
            make.centerX.equalToSuperview()
            make.top.equalTo(safeArea).offset(30)
            make.height.equalTo(60)
        }
        
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.leading.equalTo(emailTextFieldBackground).offset(10)
            make.trailing.equalTo(emailTextFieldBackground).offset(-10)
            make.centerY.equalTo(emailTextFieldBackground)
            make.height.equalTo(emailTextFieldBackground).multipliedBy(0.9)
        }
        
        view.addSubview(passwordTextFieldBackground)
        passwordTextFieldBackground.snp.makeConstraints { make in
            make.width.equalTo(safeArea).multipliedBy(0.85)
            make.centerX.equalToSuperview()
            make.top.equalTo(emailTextFieldBackground.snp.bottom).offset(30)
            make.height.equalTo(60)
        }
        
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.leading.equalTo(passwordTextFieldBackground).offset(10)
            make.trailing.equalTo(passwordTextFieldBackground).offset(-10)
            make.centerY.equalTo(passwordTextFieldBackground)
            make.height.equalTo(passwordTextFieldBackground).multipliedBy(0.9)
        }
        
        view.addSubview(errorLabel)
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextFieldBackground.snp.bottom)
            make.width.equalTo(passwordTextFieldBackground).multipliedBy(0.7)
            make.centerX.equalTo(passwordTextFieldBackground)
            make.height.equalTo(44)
        }
        
        view.addSubview(LoginButton)
        LoginButton.snp.makeConstraints { make in
            make.top.equalTo(errorLabel.snp.bottom).offset(30)
            make.centerX.equalTo(passwordTextField)
            make.height.equalTo(44)
        }
    }
    
    private func setupBinders() {
        viewModel.errorPublisher.sink { [weak self] error in
            guard let self = self, let error = error else { return }
            self.errorLabel.text = error
        }.store(in: &cancellables)
        
        viewModel.successPublisher.sink { success in
            guard success else { return }
            ChatCoordinator().start()
        }.store(in: &cancellables)
    }
}
// MARK: - Actions
extension LoginViewController {
    @objc private func didTapRegisterButton(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        viewModel.auth(email: email, password: password)
    }
}
