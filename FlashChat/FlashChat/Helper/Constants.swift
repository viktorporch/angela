//
//  Constants.swift
//  FlashChat
//
//  Created by Victor on 22.12.2023.
//

import UIKit

enum Constants {
    enum Colors {
        static let brandBlue: UIColor = UIColor(named: "BrandBlue") ?? .systemCyan
        static let brandLightBlue: UIColor = UIColor(named: "BrandLightBlue") ?? .blue.withAlphaComponent(0.5)
        static let brandPurple: UIColor = UIColor(named: "BrandPurple") ?? .purple
        static let brandLightPurple: UIColor = UIColor(named: "BrandLightPurple") ?? .purple.withAlphaComponent(0.5)
    }
    
    enum Images {
        static let logoImage: UIImage? = UIImage(named: "AppIcon")
        static let textFieldImage: UIImage? = UIImage(named: "textfield")
        static let youAvatar: UIImage? = UIImage(named: "YouAvatar")
        static let meAvatar: UIImage? = UIImage(named: "MeAvatar")
    }
    
    enum Strings {
        static let titleText: String = "FlashChat"
        static let registerButtonTitle: String = "Register"
        static let logInButtonTitle: String = "Log In"
        static let sendMessagePlaceholder: String = "Enter message text..."
    }
}
