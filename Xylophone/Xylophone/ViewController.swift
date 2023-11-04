//
//  ViewController.swift
//  Xylophone
//
//  Created by Victor on 04.11.2023
//

import UIKit
import AVKit

struct Constants {
    static let colors = [
        UIColor(red: 251/255.0, green: 101/255.0, blue: 72/255.0, alpha: 1),
        UIColor(red: 252/255.0, green: 167/255.0, blue: 0/255.0, alpha: 1),
        UIColor(red: 252/255.0, green: 211/255.0, blue: 0/255.0, alpha: 1),
        UIColor(red: 91/255.0, green: 203/255.0, blue: 117/255.0, alpha: 1),
        UIColor(red: 117/255.0, green: 119/255.0, blue: 222/255.0, alpha: 1),
        UIColor(red: 71/255.0, green: 149/255.0, blue: 255/255.0, alpha: 1),
        UIColor(red: 189/255.0, green: 120/255.0, blue: 230/255.0, alpha: 1),
    ]
    static let sounds = Array("ABCDEFG")
}

class ViewController: UIViewController {
    
    private lazy var player = AVPlayer()
    private lazy var buttons: [UIButton] = Constants.sounds.enumerated().compactMap {
        let button = UIButton()
        button.backgroundColor = Constants.colors[$0]
        button.setTitle(String($1), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.tag = $0
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    private func setupUI() {
        let safeArea = view.safeAreaLayoutGuide
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .white
        view.addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 5).isActive = true
        stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 5).isActive = true
        stackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -5).isActive = true
        stackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -5).isActive = true
        
        buttons.enumerated().forEach {
            stackView.addArrangedSubview($1)
            $1.translatesAutoresizingMaskIntoConstraints = false
            $1.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1.0 - 0.04 * CGFloat($0)).isActive = true
        }
    }
    
    @objc func didTapButton(_ sender: UIButton) {
        var url: URL? = nil
        url = Bundle.main.url(
            forResource: "Sounds/\(Constants.sounds[sender.tag])",
            withExtension: "wav")
        guard let url = url else { return }
        player.replaceCurrentItem(with: AVPlayerItem(url: url))
        player.play()
        UIView.animate(withDuration: 0.1, delay: 0, options: [.autoreverse]) {
            sender.alpha = 0.5
        } completion: { _ in
            sender.alpha = 1
        }
        
    }
    
}
