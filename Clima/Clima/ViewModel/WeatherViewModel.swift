//
//  WeatherViewModel.swift
//  Clima
//
//  Created by Victor  on 24.11.2023
//

import Foundation
import Combine
import CoreLocation

enum WeatherError: Error {
    case disabledLocations
}

final class WeatherViewModel: NSObject {
    
    private var locationManager: CLLocationManager!
    private var cancellables = Set<AnyCancellable>()
    @Published var cityName = ""
    @Published var temperature = 0
    @Published var weatherIcon = ""
    @Published var error: Error?
    
    func fetch(cityName: String) {
        WeatherManger.shared.fetchWeather(q: cityName, type: WeatherResponse.self)
            .receive(on: RunLoop.main, options: nil)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.error = error
                    print(error)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.cityName = response.name
                self.temperature = Int(round(response.main.temp))
                self.weatherIcon = self.setWeatherIcon(response.weather.first!.id)
            })
            .store(in: &cancellables)
    }
    
    func fetch() {
        startLocationManager()
    }
}
// MARK: - Helper Methods
extension WeatherViewModel {
    private func setWeatherIcon(_ id: Int) -> String {
        print(id)
        switch id {
            case 200...299:
                return "cloud.bolt.fill"
            case 300...399:
                return "cloud.drizzle.fill"
            case 500...599:
                return "cloud.rain.fill"
            case 600...699:
                return "cloud.snow.fill"
            case 700...799:
                return "cloud.fog.fill"
            case 800:
                return "sun.max.fill"
            case 801...899:
                return "smoke.fill"
            default:
                return ""
            }
    }
    
    private func startLocationManager() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}
// MARK: - CLLocationManagerDelegate
extension WeatherViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        if location.horizontalAccuracy >= 0 && location.horizontalAccuracy < manager.desiredAccuracy {
            manager.stopUpdatingLocation()
            WeatherManger.shared.fetchWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude, type: WeatherResponse.self)
                .receive(on: RunLoop.main, options: nil)
                .sink(receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .failure(let error):
                        self?.error = error
                    case .finished:
                        break
                    }
                }, receiveValue: { [weak self] response in
                    guard let self = self else { return }
                    self.cityName = response.name
                    self.temperature = Int(round(response.main.temp))
                    self.weatherIcon = self.setWeatherIcon(response.weather.first!.id)
                })
                .store(in: &cancellables)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        switch locationManager.authorizationStatus {
        case .denied, .restricted:
            error = WeatherError.disabledLocations
        default:
            locationManager.startUpdatingLocation()
        }
    }
}
