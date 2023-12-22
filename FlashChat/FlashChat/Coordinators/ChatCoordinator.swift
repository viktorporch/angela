//
//  ChatCoordinator.swift
//  FlashChat
//
//  Created by Victor on 22.12.2023.
//

import UIKit

final class ChatCoordinator: CoordinatorProtocol {
    func start() {
        let vc = ChatViewController(viewModel: ChatViewModel())
        let navVC = UINavigationController(rootViewController: vc)
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(navVC)
    }
}
