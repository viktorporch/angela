//
//  LoginViewModel.swift
//  FlashChat
//
//  Created by Victor on 22.12.2023.
//

import Foundation
import Combine

final class LoginViewModel: LoginViewModelProtocol {
    @Published var error: String?
    @Published var success = false
    var errorPublisher: Published<String?>.Publisher { $error}
    var successPublisher: Published<Bool>.Publisher { $success }
    
    func auth(email: String, password: String) {
        FirebaseManager.shared.auth(login: email, password: password) { [weak self] result in
            switch result {
            case .success(_):
                self?.success = true
            case .failure(let error):
                self?.error = error.localizedDescription
            }
        }
    }
    
    func fetch() {}
}
