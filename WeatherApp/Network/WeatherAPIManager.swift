//
//  WeatherAPIManager.swift
//  WeatherApp
//
//  Created by Narinder Singh on 10/25/24.
//

import Foundation
import CoreLocation

protocol WeatherAPIManagerProtocol {
    func fetchWeather(forCity city: String, completion: @escaping (Result<WeatherData, Error>) -> Void)
    func fetchWeather(forCoordinates coordinates: CLLocationCoordinate2D, completion: @escaping (Result<WeatherData, Error>) -> Void)
}

class WeatherAPIManager: WeatherAPIManagerProtocol {
    private let apiKey = "0773fcfa2c566ed5c4433a04a21b17f8" 
    
    func fetchWeather(forCity city: String, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)"
        performRequest(with: urlString, completion: completion)
    }

    func fetchWeather(forCoordinates coordinates: CLLocationCoordinate2D, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&appid=\(apiKey)"
        performRequest(with: urlString, completion: completion)
    }

    private func performRequest(with urlString: String, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                completion(.success(weatherData))
            } catch let decodingError {
                completion(.failure(decodingError))
            }
        }.resume()
    }
}
