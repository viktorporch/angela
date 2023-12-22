//
//  WelcomeViewController.swift
//  FlashChat
//
//  Created by Victor on 22.12.2023.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 40, weight: .heavy)
        label.textColor = Constants.Colors.brandBlue
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.text = "⚡️"
        return label
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.Strings.registerButtonTitle, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 25)
        button.setTitleColor(Constants.Colors.brandBlue, for: .normal)
        button.backgroundColor = Constants.Colors.brandLightBlue
        button.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.Strings.logInButtonTitle, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 25)
        button.setTitleColor(Constants.Colors.brandLightBlue, for: .normal)
        button.backgroundColor = Constants.Colors.brandBlue
        button.addTarget(self, action: #selector(didTapLogInButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupBinders()
        showTitle()
    }
}
// MARK: - Methods
extension WelcomeViewController {
    private func setupViews() {
        view.backgroundColor = .white
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.lessThanOrEqualTo(safeArea.snp.width).multipliedBy(0.7)
        }
        
        view.addSubview(logInButton)
        logInButton.snp.makeConstraints { make in
            make.leading.equalTo(safeArea)
            make.trailing.equalTo(safeArea)
            make.bottom.equalTo(safeArea)
            make.height.equalTo(44)
        }
        
        view.addSubview(registerButton)
        registerButton.snp.makeConstraints { make in
            make.leading.equalTo(safeArea)
            make.trailing.equalTo(safeArea)
            make.bottom.equalTo(logInButton.snp.top).offset(-5)
            make.height.equalTo(44)
        }
        
    }
    
    private func showTitle() {
        for (index, letter) in Constants.Strings.titleText.enumerated() {
            Timer.scheduledTimer(withTimeInterval: 0.1 * Double(index), repeats: false) { timer in
                self.titleLabel.text?.append(letter)
            }
        }
    }
    
    private func setupBinders() {
        
    }
}
// MARK: - Actions
extension WelcomeViewController {
    @objc func didTapRegisterButton() {
        RegisterCoordinator(self).start()
    }
    
    @objc func didTapLogInButton() {
        LoginCoordinator(self).start()
    }
}
