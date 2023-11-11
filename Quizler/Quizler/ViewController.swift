//
//  ViewController.swift
//  Quizler
//
//  Created by Victor on 11.11.2023.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    
    let bottomBGImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Background-Bubbles")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let secondButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "Rectangle"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 1
        return button
    }()
    
    let firstButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "Rectangle"), for: .normal)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 0
        return button
    }()
    
    let thirdButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "Rectangle"), for: .normal)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 2
        return button
    }()
    
    let progressBar: UIProgressView = {
        let pv = UIProgressView()
        pv.progress = 0.0
        pv.progressTintColor = .systemPink
        pv.trackTintColor = .white
        pv.translatesAutoresizingMaskIntoConstraints = false
        return pv
    }()
    
    let scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "Score: 0"
        label.font = .systemFont(ofSize: 15)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let questionContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let questionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 35)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.3
        label.numberOfLines = 4
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var model = Model()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupActions()
        startNewGameUI()
        
    }
    
    private func startNewGameUI() {
        firstButton.isHidden = true
        thirdButton.isHidden = true
        secondButton.setTitle("Start NewGame", for: .normal)
        secondButton.removeTarget(self, action: nil, for: .touchUpInside)
        secondButton.addTarget(self, action: #selector(startNewGame), for: .touchUpInside)
    }
    
    private func setupActions() {
        secondButton.addTarget(self, action: #selector(startNewGame), for: .touchUpInside)
        firstButton.addTarget(self, action: #selector(didTapAnswerButton(_:)), for: .touchUpInside)
        thirdButton.addTarget(self, action: #selector(didTapAnswerButton(_:)), for: .touchUpInside)
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 69/255, green: 74/255, blue: 104/255, alpha: 1)
        
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(bottomBGImageView)
        view.addSubview(progressBar)
        view.addSubview(secondButton)
        view.addSubview(thirdButton)
        view.addSubview(firstButton)
        view.addSubview(scoreLabel)
        view.addSubview(questionContainer)
        questionContainer.addSubview(questionLabel)
        
        
        NSLayoutConstraint.activate([
            bottomBGImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomBGImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBGImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            progressBar.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            progressBar.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 10),
            progressBar.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.9),
            
            thirdButton.bottomAnchor.constraint(equalTo: progressBar.topAnchor, constant: -20),
            thirdButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            thirdButton.heightAnchor.constraint(equalToConstant: 50),
            thirdButton.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.9),
            
            secondButton.bottomAnchor.constraint(equalTo: thirdButton.topAnchor, constant: -20),
            secondButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            secondButton.heightAnchor.constraint(equalToConstant: 50),
            secondButton.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.9),
            
            firstButton.bottomAnchor.constraint(equalTo: secondButton.topAnchor, constant: -20),
            firstButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            firstButton.heightAnchor.constraint(equalToConstant: 50),
            firstButton.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.9),
            
            scoreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            scoreLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            
            questionContainer.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            questionContainer.bottomAnchor.constraint(equalTo: firstButton.topAnchor),
            questionContainer.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            
            questionLabel.centerYAnchor.constraint(equalTo: questionContainer.centerYAnchor),
            questionLabel.leadingAnchor.constraint(equalTo: questionContainer.leadingAnchor, constant: 10),
            questionLabel.trailingAnchor.constraint(equalTo: questionContainer.trailingAnchor, constant: -10),
        ])
    }
    
    func updateUI() {
        scoreLabel.text = "Score: \(model.score)"
        progressBar.progress = Float(model.progress)
        
        guard let question = model.next() else {
            questionLabel.text = "Game End\nYour score: \(model.score)"
            startNewGameUI()
            return
        }
        firstButton.setTitle(question.a[0], for: .normal)
        secondButton.setTitle(question.a[1], for: .normal)
        thirdButton.setTitle(question.a[2], for: .normal)
        questionLabel.text = question.q
        
    }

}
// MARK: - Actions
extension ViewController {
    @objc func didTapAnswerButton(_ sender: UIButton) {
        let result = model.answer(answerIndex: sender.tag)
        UIView.animate(withDuration: 0.5, delay: 0, options: [.autoreverse]) {
            sender.backgroundColor = result ? .green : .red
        } completion: { finished in
            sender.backgroundColor = .clear
            self.updateUI()
        }
    }
    
    @objc func startNewGame() {
        model.newGame()
        secondButton.removeTarget(self, action: nil, for: .touchUpInside)
        secondButton.addTarget(self, action: #selector(didTapAnswerButton(_:)), for: .touchUpInside)
        firstButton.isHidden = false
        thirdButton.isHidden = false
        updateUI()
    }
}
