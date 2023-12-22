//
//  LoginCoordinator.swift
//  FlashChat
//
//  Created by Victor on 22.12.2023.
//

import UIKit

final class LoginCoordinator: CoordinatorProtocol {
    private let parentVC: UIViewController
    
    init(_ parentVC: UIViewController) {
        self.parentVC = parentVC
    }
    
    func start() {
        let vc = LoginViewController(viewModel: LoginViewModel())
        if let navVC = parentVC.navigationController {
            navVC.pushViewController(vc, animated: true)
        } else {
            parentVC.present(vc, animated: true, completion: nil)
        }
    }
}
