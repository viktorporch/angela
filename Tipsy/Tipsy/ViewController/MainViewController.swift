//
//  MainViewController.swift
//  Tipsy
//
//  Created by Victor  on 24.11.2023
//

import UIKit

class MainViewController: UIViewController {
    
    private let billHeader: UILabel = {
        let label = UILabel()
        label.text = "Enter bill total"
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tipHeader: UILabel = {
        let label = UILabel()
        label.text = "Select tip"
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let splitHeader: UILabel = {
        let label = UILabel()
        label.text = "Choose Split"
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "e.g. 123.56"
        textField.textAlignment = .center
        textField.keyboardType = .decimalPad
        textField.textColor = Constants.darkColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let greenBackground: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.lightColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var zeroButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: textSize, weight: .light)
        button.setTitle("0%", for: .normal)
        button.setTitleColor(Constants.darkColor, for: .normal)
        button.setTitleColor(Constants.lightColor, for: .selected)
        button.tintColor = Constants.darkColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var tenButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: textSize, weight: .light)
        button.setTitle("10%", for: .normal)
        button.setTitleColor(Constants.darkColor, for: .normal)
        button.setTitleColor(Constants.lightColor, for: .selected)
        button.tintColor = Constants.darkColor
        button.isSelected = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var twentyButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: textSize, weight: .light)
        button.setTitle("20%", for: .normal)
        button.setTitleColor(Constants.darkColor, for: .normal)
        button.setTitleColor(Constants.lightColor, for: .selected)
        button.tintColor = Constants.darkColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var stepsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: textSize, weight: .light)
        label.textColor = Constants.darkColor
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 2
        stepper.stepValue = 1
        stepper.value = persons
        stepper.addTarget(self, action: #selector(didTapStepper), for: .touchUpInside)
        stepper.translatesAutoresizingMaskIntoConstraints = false
        return stepper
    }()
    
    private lazy var calculateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("CALCULATE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Constants.darkColor
        button.titleLabel?.font = Constants.calcButtonFont
        button.addTarget(self, action: #selector(didTapCalculateButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let hPadding: CGFloat = 40.0
    private let vPadding: CGFloat = 20.0
    private let textFieldHeight: CGFloat = 35.0
    private var textSize: CGFloat {
        textFieldHeight * 0.8
    }
    
    private var tipPercent = 0.1
    private var persons = 4.0 {
        didSet {
            stepsLabel.text = "\(Int(persons))"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        addGestureRecognizers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        calculateButton.layer.cornerRadius = calculateButton.bounds.height * 0.25
    }
}
// MARK: - Methods
extension MainViewController {
    func addGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func setupViews() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.backgroundColor = .white
        
        view.addSubview(billHeader)
        NSLayoutConstraint.activate([
            billHeader.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: vPadding),
            billHeader.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: hPadding),
        ])
        
        view.addSubview(textField)
        textField.font = .systemFont(ofSize: textFieldHeight * 0.9, weight: .light)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: billHeader.bottomAnchor, constant: vPadding),
            textField.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            textField.heightAnchor.constraint(equalToConstant: textFieldHeight),
            textField.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.9)
        ])
        
        view.addSubview(greenBackground)
        NSLayoutConstraint.activate([
            greenBackground.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            greenBackground.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            greenBackground.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: vPadding * 1.5),
            greenBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(tipHeader)
        NSLayoutConstraint.activate([
            tipHeader.topAnchor.constraint(equalTo: greenBackground.topAnchor, constant: vPadding),
            tipHeader.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: hPadding),
        ])
        
        view.addSubview(zeroButton)
        zeroButton.sizeToFit()
        zeroButton.addTarget(self, action: #selector(didTapZeroButton(_:)), for: .touchUpInside)
        NSLayoutConstraint.activate([
            zeroButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: hPadding),
            zeroButton.topAnchor.constraint(equalTo: tipHeader.bottomAnchor, constant: vPadding),
        ])
        
        view.addSubview(tenButton)
        tenButton.sizeToFit()
        tenButton.addTarget(self, action: #selector(didTapTenButton(_:)), for: .touchUpInside)
        NSLayoutConstraint.activate([
            tenButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            tenButton.topAnchor.constraint(equalTo: tipHeader.bottomAnchor, constant: vPadding),
        ])
        
        view.addSubview(twentyButton)
        twentyButton.sizeToFit()
        twentyButton.addTarget(self, action: #selector(didTapTwentyButton(_:)), for: .touchUpInside)
        NSLayoutConstraint.activate([
            twentyButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -hPadding),
            twentyButton.topAnchor.constraint(equalTo: tipHeader.bottomAnchor, constant: vPadding),
        ])
        
        view.addSubview(splitHeader)
        NSLayoutConstraint.activate([
            splitHeader.topAnchor.constraint(equalTo: tenButton.bottomAnchor, constant: vPadding),
            splitHeader.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: hPadding),
        ])
        
        view.addSubview(stepsLabel)
        stepsLabel.text = "\(Int(persons))"
        NSLayoutConstraint.activate([
            stepsLabel.trailingAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: -hPadding),
            stepsLabel.topAnchor.constraint(equalTo: splitHeader.bottomAnchor, constant: vPadding)
        ])
        
        view.addSubview(stepper)
        NSLayoutConstraint.activate([
            stepper.leadingAnchor.constraint(equalTo: safeArea.centerXAnchor),
            stepper.topAnchor.constraint(equalTo: splitHeader.bottomAnchor, constant: vPadding)
        ])
        
        view.addSubview(calculateButton)
        NSLayoutConstraint.activate([
            calculateButton.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.6),
            calculateButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            calculateButton.heightAnchor.constraint(equalToConstant: 44),
            calculateButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
        
    }
    
    private func selectOneButton(_ sender: UIButton) {
        zeroButton.isSelected = false
        tenButton.isSelected = false
        twentyButton.isSelected = false
        sender.isSelected = true
        textField.resignFirstResponder()
    }
    
    private func invalidValueAlert() {
        let alert = UIAlertController(title: "Error", message: "Invalid input", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
// MARK: - Actions
extension MainViewController {
    @objc func didTapZeroButton(_ sender: UIButton) {
        selectOneButton(sender)
        tipPercent = 0.0
    }
    
    @objc func didTapTenButton(_ sender: UIButton) {
        selectOneButton(sender)
        tipPercent = 0.1
    }
    
    @objc func didTapTwentyButton(_ sender: UIButton) {
        selectOneButton(sender)
        tipPercent = 0.2
    }
    
    @objc func didTapStepper(_ sender: UIStepper) {
        persons = sender.value
        textField.resignFirstResponder()
    }
    
    @objc func tapGestureAction(_ sender: UITapGestureRecognizer) {
        let view = sender.view
        let location = sender.location(in: view)
        let subview = view?.hitTest(location, with: nil)
        guard let subview = subview else {
            return
        }
        if subview != textField {
            textField.resignFirstResponder()
        }
    }
    
    @objc func didTapCalculateButton(_ sender: UIButton) {
        guard let text = textField.text, let value = Double(text) else {
            invalidValueAlert()
            return
        }
        let vc = ResultViewController()
        vc.update(
            result: round(value * tipPercent / persons * 100.0) / 100.0,
            persons: Int(persons),
            percent: Int(tipPercent * 100))
        present(vc, animated: true, completion: nil)
    }
}
