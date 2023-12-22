//
//  RegisterViewModelProtocol.swift
//  FlashChat
//
//  Created by Victor on 22.12.2023.
//

import Foundation
import Combine

protocol RegisterViewModelProtocol: ViewModelProtocol {
    var errorPublisher: Published<String?>.Publisher { get }
    var successPublisher: Published<Bool>.Publisher { get }
    
    func register(email: String, password: String)
}
