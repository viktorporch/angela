//
//  RegisterViewModel.swift
//  FlashChat
//
//  Created by Victor on 22.12.2023.
//

import Foundation
import FirebaseAuth
import Combine


final class RegisterViewModel: RegisterViewModelProtocol {
    
    @Published private(set) var success: Bool = false
    var successPublisher: Published<Bool>.Publisher { $success }
    
    @Published private(set) var error: String?
    var errorPublisher: Published<String?>.Publisher { $error }
    
    private var cancellables = Set<AnyCancellable>()
    
    func register(email: String, password: String) {
        FirebaseManager.shared.register(login: email, password: password) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.error = error.localizedDescription
            case .success(_):
                self?.success = true
            }
        }
    }
    
    func fetch() {
        
    }
    
    
}
