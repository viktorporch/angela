//
//  ViewController.swift
//  Destini
//
//  Created by Victor on 24.11.2023
//

import UIKit

class ViewController: UIViewController {

    let backgroundView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "background")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let storyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25)
        label.numberOfLines = 0
        label.text = "StoryLabel"
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    let labelContainer = UIView()
    
    let firstChoiceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemPink
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.5
        return button
    }()
    
    let secondChoiceButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemPurple
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.5
        return button
    }()
    
    private lazy var model = StoryBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        updateUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        firstChoiceButton.layer.cornerRadius = firstChoiceButton.bounds.height * 0.25
        secondChoiceButton.layer.cornerRadius = secondChoiceButton.bounds.height * 0.25
    }
}
// MARK: - Methods
extension ViewController {
    private func setupViews() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        view.addSubview(secondChoiceButton)
        secondChoiceButton.translatesAutoresizingMaskIntoConstraints = false
        secondChoiceButton.addTarget(self, action: #selector(didTapChoiceButton(_:)), for: .touchUpInside)
        NSLayoutConstraint.activate([
            secondChoiceButton.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.9),
            secondChoiceButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            secondChoiceButton.heightAnchor.constraint(equalToConstant: 80),
            secondChoiceButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 0),
        ])
        
        view.addSubview(firstChoiceButton)
        firstChoiceButton.translatesAutoresizingMaskIntoConstraints = false
        firstChoiceButton.addTarget(self, action: #selector(didTapChoiceButton(_:)), for: .touchUpInside)
        NSLayoutConstraint.activate([
            firstChoiceButton.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.9),
            firstChoiceButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            firstChoiceButton.heightAnchor.constraint(equalToConstant: 80),
            firstChoiceButton.bottomAnchor.constraint(equalTo: secondChoiceButton.topAnchor, constant: -20),
        ])
        
        view.addSubview(labelContainer)
        labelContainer.addSubview(storyLabel)
        labelContainer.translatesAutoresizingMaskIntoConstraints = false
        storyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelContainer.topAnchor.constraint(equalTo: safeArea.topAnchor),
            labelContainer.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.9),
            labelContainer.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            labelContainer.bottomAnchor.constraint(equalTo: firstChoiceButton.topAnchor, constant: -10),
            
            storyLabel.centerXAnchor.constraint(equalTo: labelContainer.centerXAnchor),
            storyLabel.centerYAnchor.constraint(equalTo: labelContainer.centerYAnchor),
            storyLabel.widthAnchor.constraint(equalTo: labelContainer.widthAnchor)
        ])
    }
    
    private func updateUI() {
        firstChoiceButton.setTitle(model.choice1, for: .normal)
        secondChoiceButton.setTitle(model.choice2, for: .normal)
        storyLabel.text = model.title
    }
}
// MARK: - Actions
extension ViewController {
    @objc func didTapChoiceButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25, delay: 0, options: [.autoreverse]) {
            sender.alpha = 0.3
        } completion: { [weak self] finished in
            sender.alpha = 1
            self?.model.nextStory(choice: sender.titleLabel!.text!)
            self?.updateUI()
        }
    }
}
