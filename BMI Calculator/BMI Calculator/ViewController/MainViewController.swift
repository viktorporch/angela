//
//  MainViewController.swift
//  BMI Calculator
//
//  Created by Victor on 11.11.2023.
//

import UIKit

class MainViewController: UIViewController {

    private let backgroundView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "calculate_background")
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var heightSlider: UISlider = {
        let slider = UISlider()
        slider.addTarget(self, action: #selector(didChangeHeightSlider), for: .valueChanged)
        slider.minimumValue = 1.2
        slider.maximumValue = 2.5
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.thumbTintColor = Constants.lightColor.withAlphaComponent(0.75)
        slider.tintColor = Constants.lightColor.withAlphaComponent(0.75)
        slider.maximumTrackTintColor = .lightGray.withAlphaComponent(0.75)
        return slider
    }()
    
    private lazy var weightSlider: UISlider = {
        let slider = UISlider()
        slider.addTarget(self, action: #selector(didChangeWeightSlider), for: .valueChanged)
        slider.minimumValue = 35
        slider.maximumValue = 150
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.thumbTintColor = Constants.lightColor.withAlphaComponent(0.75)
        slider.tintColor = Constants.lightColor.withAlphaComponent(0.75)
        slider.maximumTrackTintColor = .lightGray.withAlphaComponent(0.75)
        return slider
    }()
    
    private lazy var calculateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("CALCULATE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = Constants.buttonFont
        button.backgroundColor = Constants.darkColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapCalculateButton), for: .touchUpInside)
        return button
    }()
    
    private let weightLabel: UILabel = {
        let label = UILabel()
        label.text = "Weight"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let heightLabel: UILabel = {
        let label = UILabel()
        label.text = "Height"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weightValueLabel: UILabel = {
        let label = UILabel()
        label.text = "kg"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let heightValueLabel: UILabel = {
        let label = UILabel()
        label.text = "m"
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let labelContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 35, weight: .semibold)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.text = "CALCULATE\nYOUR BMI"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var heightValue: Float {
        round(heightSlider.value * 100.0) / 100.0
    }
    
    var weightValue: Float {
        round(weightSlider.value / 0.5) * 0.5
    }
    
    private(set) var model = CalculatorBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        calculateButton.layer.cornerRadius = calculateButton.bounds.height * 0.15
    }
}
// MARK: - Methods
extension MainViewController {
    private func setupViews() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(backgroundView)
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        view.addSubview(calculateButton)
        NSLayoutConstraint.activate([
            calculateButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            calculateButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            calculateButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            calculateButton.heightAnchor.constraint(equalToConstant: 44),
        ])
        
        view.addSubview(weightSlider)
        NSLayoutConstraint.activate([
            weightSlider.bottomAnchor.constraint(equalTo: calculateButton.topAnchor, constant: -20),
            weightSlider.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            weightSlider.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
        ])
        
        view.addSubview(weightLabel)
        NSLayoutConstraint.activate([
            weightLabel.leadingAnchor.constraint(equalTo: weightSlider.leadingAnchor),
            weightLabel.bottomAnchor.constraint(equalTo: weightSlider.topAnchor, constant: -20),
        ])
        
        view.addSubview(weightValueLabel)
        NSLayoutConstraint.activate([
            weightValueLabel.trailingAnchor.constraint(equalTo: weightSlider.trailingAnchor),
            weightValueLabel.bottomAnchor.constraint(equalTo: weightSlider.topAnchor, constant: -20),
        ])
        
        view.addSubview(heightSlider)
        NSLayoutConstraint.activate([
            heightSlider.bottomAnchor.constraint(equalTo: weightLabel.topAnchor, constant: -20),
            heightSlider.leadingAnchor.constraint(equalTo: weightSlider.leadingAnchor),
            heightSlider.trailingAnchor.constraint(equalTo: weightSlider.trailingAnchor),
        ])
        
        view.addSubview(heightLabel)
        NSLayoutConstraint.activate([
            heightLabel.leadingAnchor.constraint(equalTo: heightSlider.leadingAnchor),
            heightLabel.bottomAnchor.constraint(equalTo: heightSlider.topAnchor, constant: -20),
        ])
        
        view.addSubview(heightValueLabel)
        NSLayoutConstraint.activate([
            heightValueLabel.trailingAnchor.constraint(equalTo: heightSlider.trailingAnchor),
            heightValueLabel.bottomAnchor.constraint(equalTo: heightSlider.topAnchor, constant: -20),
        ])
        
        view.addSubview(labelContainer)
        NSLayoutConstraint.activate([
            labelContainer.topAnchor.constraint(equalTo: safeArea.topAnchor),
            labelContainer.leadingAnchor.constraint(equalTo: weightSlider.leadingAnchor),
            labelContainer.trailingAnchor.constraint(equalTo: weightSlider.trailingAnchor),
            labelContainer.bottomAnchor.constraint(equalTo: heightLabel.topAnchor),
        ])
        
        labelContainer.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: labelContainer.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: labelContainer.trailingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: labelContainer.centerYAnchor),
        ])
        
        heightSlider.value = (heightSlider.maximumValue + heightSlider.minimumValue) * 0.5
        weightSlider.value = (weightSlider.maximumValue + weightSlider.minimumValue) * 0.45
        heightValueLabel.text = "\(heightValue)m"
        weightValueLabel.text = "\(weightValue)kg"
    }
}
// MARK: - Actions
extension MainViewController {
    @objc func didChangeHeightSlider(_ sender: UISlider) {
        heightValueLabel.text = "\(heightValue)m"
    }
    
    @objc func didChangeWeightSlider(_ sender: UISlider) {
        weightValueLabel.text = "\(weightValue)kg"
    }
    
    @objc func didTapCalculateButton() {
        let vc = ResultViewController()
        model.calculateBMI(weight: weightSlider.value, height: heightSlider.value)
        vc.setValues(value: model.getValue(), advice: model.getAdvice(), color: model.getColor())
        present(vc, animated: true, completion: nil)
    }
}
