//
//  ViewController.swift
//  Clima
//
//  Created by Victor  on 24.11.2023
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    private var cancellables = Set<AnyCancellable>()
    private let viewModel = WeatherViewModel()
    
    private lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.searchTextField.textColor = UIColor(named: "weatherColour") ?? .label
        sb.delegate = self
        return sb
    }()
    private let backgroundView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "background")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = UIColor(named: "weatherColour") ?? .label
        return imageView
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "weatherColour") ?? .label
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let placeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "weatherColour") ?? .label
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 35, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavBar()
        setupBinders()
        
        viewModel.fetch()
    }
}
// MARK: - Methods
extension ViewController {
    private func setupNavBar() {
        let leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "location.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(didTapLocationButton))
        leftBarButtonItem.tintColor = UIColor(named: "weatherColour") ?? .label
        
        let rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass.circle"),
            style: .plain,
            target: self,
            action: #selector(didTapSearchButton))
        rightBarButtonItem.tintColor = UIColor(named: "weatherColour") ?? .label
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.titleView = searchBar
    }
    
    private func setupViews() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(backgroundView)
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        view.addSubview(iconImage)
        NSLayoutConstraint.activate([
            iconImage.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            iconImage.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
        ])
        
        view.addSubview(tempLabel)
        NSLayoutConstraint.activate([
            tempLabel.trailingAnchor.constraint(equalTo: iconImage.trailingAnchor),
            tempLabel.topAnchor.constraint(equalTo: iconImage.bottomAnchor, constant: 5),
        ])
        
        view.addSubview(placeLabel)
        NSLayoutConstraint.activate([
            placeLabel.trailingAnchor.constraint(equalTo: iconImage.trailingAnchor),
            placeLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 5),
        ])
        
    }
    
    private func setupBinders() {
        viewModel.$weatherIcon.sink { [weak self] value in
            self?.iconImage.image = UIImage(
                systemName: value,
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 100))
        }.store(in: &cancellables)
        
        viewModel.$temperature.sink { [weak self] value in
            self?.tempLabel.attributedText = NSMutableAttributedString()
                .bold("\(value)")
                .normal("°C")
        }.store(in: &cancellables)
        
        viewModel.$cityName.sink { [weak self] value in
            self?.placeLabel.text = value
        }.store(in: &cancellables)
        
        viewModel.$error.sink { [weak self] error in
            guard let self = self, let error = error else { return }
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }.store(in: &cancellables)
    }
}
// MARK: - Actions
extension ViewController {
    @objc func didTapLocationButton() {
        viewModel.fetch()
    }
    
    @objc func didTapSearchButton() {
        guard let text = searchBar.text, !text.isEmpty else { return }
        viewModel.fetch(cityName: text)
    }
}
// MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        viewModel.fetch(cityName: text)
    }
}
