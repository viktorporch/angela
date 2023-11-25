//
//  ResultViewController.swift
//  Tipsy
//
//  Created by Victor  on 24.11.2023
//

import UIKit

class ResultViewController: UIViewController {
    
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.lightColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let personLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 25, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Total per person"
        return label
    }()
    
    let resultLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.darkColor
        label.font = .systemFont(ofSize: 35, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 20, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 2
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
        
        view.backgroundColor = .white
        
        view.addSubview(backgroundView)
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35),
        ])
        
        view.addSubview(resultLabel)
        NSLayoutConstraint.activate([
            resultLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            resultLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            resultLabel.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -40)
        ])
        
        view.addSubview(personLabel)
        NSLayoutConstraint.activate([
            personLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            personLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            personLabel.bottomAnchor.constraint(equalTo: resultLabel.topAnchor, constant: -20)
        ])
        
        view.addSubview(infoLabel)
        NSLayoutConstraint.activate([
            infoLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            infoLabel.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 20)
        ])
    }
    
    func update(result: Double, persons: Int, percent: Int) {
        resultLabel.text = "\(result)"
        infoLabel.text = "Split between \(persons) people, with\n\(percent)% tip."
    }
}
