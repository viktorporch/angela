//
//  ChatViewModel.swift
//  FlashChat
//
//  Created by Victor on 22.12.2023.
//

import Foundation
import Combine

final class ChatViewModel: ChatViewModelProtocol {
    @Published private(set) var error: String?
    var errorPublisher: Published<String?>.Publisher { $error }
    @Published private(set) var updateMessages = false
    var updateMessagesPublisher: Published<Bool>.Publisher { $updateMessages }
    private(set) var messages = [MessageModel]()
    
    var signOutCompletion: (() -> Void)?
    var sendMessageCompletion: (() -> Void)?
    
    init() {}
    
    func fetch() {
        fetchMessages()
    }
    
    func signOut() {
        FirebaseManager.shared.signOut { [weak self] result in
            switch result {
            case .failure(let error):
                self?.error = error.localizedDescription
            case .success(_):
                self?.signOutCompletion?()
            }
        }
    }
    
    func sendMessage(text: String?) {
        guard let text = text, let email = FirebaseManager.shared.currentUserEmail else { return }
        FirebaseManager.shared.sendMessage(
            MessageModel(
                sender: email,
                body: text,
                type: .outcome)) { [weak self] result in
                    switch result {
                    case .success(_):
                        break
                    case .failure(let error):
                        self?.error = error.localizedDescription
                    }
                }
    }
    
    private func fetchMessages() {
        FirebaseManager.shared.fetchMessages { [weak self] result in
            switch result {
            case .success(let messages):
                self?.messages = messages
                self?.updateMessages = true
                self?.sendMessageCompletion?()
            case .failure(let error):
                self?.error = error.localizedDescription
            }
        }
    }
}
