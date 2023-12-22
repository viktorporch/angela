//
//  WelcomeCoordinator.swift
//  FlashChat
//
//  Created by Victor on 22.12.2023.
//

import UIKit

final class WelcomeCoordinator: CoordinatorProtocol {
    func start() {
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?
            .changeRootViewController(UINavigationController(rootViewController: WelcomeViewController()))
    }
}
