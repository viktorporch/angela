//
//  ChatViewModelProtocol.swift
//  FlashChat
//
//  Created by Victor on 22.12.2023.
//

import Foundation

protocol ChatViewModelProtocol: ViewModelProtocol {
    var errorPublisher: Published<String?>.Publisher { get }
    var updateMessagesPublisher: Published<Bool>.Publisher { get }
    var signOutCompletion: (() -> Void)? { get set }
    var sendMessageCompletion: (() -> Void)? { get set }
    var messages: [MessageModel] { get }
    func signOut()
    func sendMessage(text: String?)
}
