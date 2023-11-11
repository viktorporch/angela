//
//  ResultViewController.swift
//  BMI Calculator
//
//  Created by Victor on 11.11.2023.
//

import UIKit

class ResultViewController: UIViewController {
    
    private let backgroundView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "result_background")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var recalculateButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapRecalculateButton), for: .touchUpInside)
        button.backgroundColor = .white
        button.titleLabel?.font = Constants.buttonFont
        button.setTitle("RECALCULATE", for: .normal)
        button.setTitleColor(Constants.darkColor, for: .normal)
        return button
    }()
    
    private let resultPlaceholder: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "YOUR RESULT"
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let resultValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 70, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let adviceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "YOUR RESULT"
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
}
// MARK: - Methods
extension ResultViewController {
    private func setupViews() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(backgroundView)
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        view.addSubview(recalculateButton)
        NSLayoutConstraint.activate([
            recalculateButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            recalculateButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            recalculateButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            recalculateButton.heightAnchor.constraint(equalToConstant: 44),
        ])
        
        view.addSubview(resultValueLabel)
        NSLayoutConstraint.activate([
            resultValueLabel.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            resultValueLabel.leadingAnchor.constraint(equalTo: recalculateButton.leadingAnchor),
            resultValueLabel.trailingAnchor.constraint(equalTo: recalculateButton.trailingAnchor),
        ])
        
        view.addSubview(resultPlaceholder)
        NSLayoutConstraint.activate([
            resultPlaceholder.bottomAnchor.constraint(equalTo: resultValueLabel.topAnchor, constant: -5),
            resultPlaceholder.leadingAnchor.constraint(equalTo: recalculateButton.leadingAnchor),
            resultPlaceholder.trailingAnchor.constraint(equalTo: recalculateButton.trailingAnchor),
        ])
        
        view.addSubview(adviceLabel)
        NSLayoutConstraint.activate([
            adviceLabel.topAnchor.constraint(equalTo: resultValueLabel.bottomAnchor, constant: 5),
            adviceLabel.leadingAnchor.constraint(equalTo: recalculateButton.leadingAnchor),
            adviceLabel.trailingAnchor.constraint(equalTo: recalculateButton.trailingAnchor),
        ])
    }
    
    func setValues(value: Double, advice: String, color: UIColor) {
        view.backgroundColor = color
        resultValueLabel.text = "\(value)"
        adviceLabel.text = advice
    }
}
// MARK: - Actions
extension ResultViewController {
    @objc func didTapRecalculateButton() {
        dismiss(animated: true, completion: nil)
    }
}
