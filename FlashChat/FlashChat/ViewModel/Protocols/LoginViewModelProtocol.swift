//
//  LoginViewModelProtocol.swift
//  FlashChat
//
//  Created by Victor on 22.12.2023.
//

import Foundation

protocol LoginViewModelProtocol: ViewModelProtocol {
    var errorPublisher: Published<String?>.Publisher { get }
    var successPublisher: Published<Bool>.Publisher { get }
    
    func auth(email: String, password: String)
}
