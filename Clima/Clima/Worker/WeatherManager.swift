//
//  WeatherManager.swift
//  Clima
//
//  Created by Victor  on 24.11.2023
//

import Foundation
import Combine

enum WeatherManagerError: Error {
    case invalidURL
    case invalidResponse
    case unknown
}

public class WeatherManger {
    private enum Constants {
        static let baseURL = "https://api.openweathermap.org/data/2.5"
        static let appID = "e41cb2ac3eef6ce33f44bd481da7d890"
    }
    
    static let shared = WeatherManger()
    private var cancellables = Set<AnyCancellable>()
    
    private init() {}
    
    func fetchWeather<T: Decodable>(lat: Double, lon: Double, type: T.Type) -> Future<T, Error> {
        return Future<T, Error> { [weak self] promise in
            guard let self = self, let url = URL(string: Constants.baseURL + "/weather?lat=\(lat)&lon=\(lon)&appid=\(Constants.appID)&units=metric") else {
                return promise(.failure(WeatherManagerError.invalidURL))
            }
            // Create publisher
            URLSession.shared.dataTaskPublisher(for: url)
            //Try to map publisher results
                .tryMap { (data: Data, response: URLResponse) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~=
                            httpResponse.statusCode else {
                                throw WeatherManagerError.invalidResponse
                            }
                    return data
                }
            // Try to decode
                .decode(type: T.self, decoder: JSONDecoder())
            // Subscribe
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as WeatherManagerError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(WeatherManagerError.unknown))
                        }
                    case .finished:
                        break
                    }
                }, receiveValue: { promise(.success($0)) })
                .store(in: &self.cancellables)
        }
    }
    
    func fetchWeather<T: Decodable>(q: String, type: T.Type) -> Future<T, Error> {
        return Future<T, Error> { [weak self] promise in
            guard let self = self, let url = URL(string: Constants.baseURL + "/weather?q=\(q.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? q)&appid=\(Constants.appID)&units=metric") else {
                return promise(.failure(WeatherManagerError.invalidURL))
            }
            // Create publisher
            URLSession.shared.dataTaskPublisher(for: url)
            //Try to map publisher results
                .tryMap { (data: Data, response: URLResponse) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~=
                            httpResponse.statusCode else {
                                throw WeatherManagerError.invalidResponse
                            }
                    return data
                }
            // Try to decode
                .decode(type: T.self, decoder: JSONDecoder())
            // Subscribe
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as WeatherManagerError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(WeatherManagerError.unknown))
                        }
                    case .finished:
                        break
                    }
                }, receiveValue: { promise(.success($0)) })
                .store(in: &self.cancellables)
        }
    }
}
