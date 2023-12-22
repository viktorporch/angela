//
//  ChatViewController.swift
//  FlashChat
//
//  Created by Victor on 22.12.2023.
//

import UIKit
import Combine
import SnapKit

class ChatViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: ChatViewModelProtocol!
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.register(OutcomeMessageViewCell.self, forCellReuseIdentifier: OutcomeMessageViewCell.identifier)
        tableView.register(IncomeMessageViewCell.self, forCellReuseIdentifier: IncomeMessageViewCell.identifier)
        return tableView
    }()
    private let bottomMessageView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colors.brandPurple
        return view
    }()
    private lazy var messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 15)
        textView.backgroundColor = .white
        textView.text = "Enter message text..."
        textView.textColor = .lightGray
        textView.delegate = self
        return textView
    }()
    private lazy var sendMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(
            UIImage(
                systemName: "paperplane.fill",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 100)),
            for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapSendMessageButton), for: .touchUpInside)
        return button
    }()
    private var keyboardShownNotification: Any!
    private var keyboardHideNotification: Any!
    
    init(viewModel: ChatViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.viewModel.signOutCompletion = {
            WelcomeCoordinator().start()
        }
        self.viewModel.sendMessageCompletion = { [weak self] in
            self?.setPlaceholder()
            self?.messageTextView.resignFirstResponder()
        }
        self.viewModel.errorPublisher.sink { [weak self] value in
            guard let self = self, let value = value else { return }
            let alert = UIAlertController(title: "Error", message: value, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }.store(in: &cancellables)
    }
    
    private var bottomMessageViewConstraint: Constraint!
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
        setupBinders()
        setupGestureRecognizers()
        
        viewModel.fetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObervers()
    }
}
// MARK: - Methods
extension ChatViewController {
    private func setupNavigationBar() {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Constants.Colors.brandBlue
        appearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)
        ]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        title = "⚡️FlashChat"
        
        let signOutButton = UIBarButtonItem(
            title: "Sign Out",
            style: .done,
            target: self,
            action: #selector(didTapSignOutButton))
        signOutButton.tintColor = .white
        navigationItem.rightBarButtonItem = signOutButton
    }
    
    private func setupBinders() {
        viewModel.errorPublisher.sink { [weak self] value in
            guard let value = value else { return }
            self?.showAlert(message: value)
        }.store(in: &cancellables)
        
        viewModel.updateMessagesPublisher.sink { [weak self] value in
            guard let self = self, value else { return }
            self.tableView.reloadData()
            let rowIndex = self.tableView.numberOfRows(inSection: 0) - 1
            guard rowIndex > 0 else { return }
            self.tableView.scrollToRow(
                at: IndexPath(row: rowIndex, section: 0),
                at: .bottom,
                animated: true)
        }.store(in: &cancellables)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    private func setupViews() {
        view.backgroundColor = Constants.Colors.brandPurple
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(bottomMessageView)
        view.addSubview(tableView)
        bottomMessageView.addSubview(messageTextView)
        bottomMessageView.addSubview(sendMessageButton)
        
        bottomMessageView.snp.makeConstraints { make in
            bottomMessageViewConstraint = make.bottom.equalTo(safeArea).constraint
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(messageTextView).offset(-20)
        }
        
        messageTextView.snp.makeConstraints { make in
            make.leading.equalTo(safeArea).offset(20)
            make.trailing.equalTo(sendMessageButton.snp.leading).offset(-20)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        
        sendMessageButton.snp.makeConstraints { make in
            make.height.equalTo(messageTextView)
            make.width.equalTo(messageTextView.snp.height)
            make.trailing.equalTo(safeArea).offset(-20)
            make.centerY.equalTo(messageTextView)
        }
        
        
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(bottomMessageView.snp.top)
        }
    }
    
    private func setPlaceholder() {
        messageTextView.text = Constants.Strings.sendMessagePlaceholder
        messageTextView.textColor = .lightGray
    }
    
    private func setupGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setupKeyboardObservers() {
        keyboardShownNotification = NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        keyboardHideNotification = NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    private func removeKeyboardObervers() {
        NotificationCenter.default.removeObserver(keyboardShownNotification!)
        NotificationCenter.default.removeObserver(keyboardHideNotification!)
    }
}
// MARK: - Actions
extension ChatViewController {
    @objc private func didTapSignOutButton() {
        viewModel.signOut()
    }
    @objc private func didTapSendMessageButton() {
        guard messageTextView.text != Constants.Strings.sendMessagePlaceholder else { return }
        viewModel.sendMessage(text: messageTextView.text)
    }
    @objc private func tapGestureAction(_ recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: view)
        if view.hitTest(location, with: nil) === messageTextView {
            return
        } else {
            messageTextView.resignFirstResponder()
        }
    }
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?
                .cgRectValue else { return }
        bottomMessageViewConstraint.deactivate()
        bottomMessageView.snp.makeConstraints { make in
            bottomMessageViewConstraint = make.bottom.equalToSuperview().offset(-keyboardSize.height).constraint
        }
    }
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        bottomMessageViewConstraint.deactivate()
        bottomMessageView.snp.makeConstraints { make in
            bottomMessageViewConstraint = make.bottom.equalTo(view.safeAreaLayoutGuide).constraint
        }
    }
}
// MARK: - UITableViewDelegate/DS
extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.messages[indexPath.row]
        switch model.type {
        case .outcome:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: OutcomeMessageViewCell.identifier, for: indexPath) as! OutcomeMessageViewCell
            cell.configure(messageText: model.body)
            return cell
        case .income:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: IncomeMessageViewCell.identifier, for: indexPath) as! IncomeMessageViewCell
            cell.configure(messageText: model.body)
            return cell
        }
    }
}
// MARK: - UITextViewDelegate
extension ChatViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == Constants.Strings.sendMessagePlaceholder && textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            setPlaceholder()
        }
    }
}
