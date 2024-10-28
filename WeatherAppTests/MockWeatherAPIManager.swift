//
//  MockWeatherAPIManager.swift
//  WeatherAppTests
//
//  Created by Kulvir Singh on 10/25/24.
//

import Combine
import CoreLocation
import XCTest
@testable import WeatherApp

class MockWeatherAPIManager: WeatherAPIManagerProtocol {
    var shouldReturnError = false
    var mockData: WeatherData?

    func fetchWeather(forCity city: String, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "TestError"])))
        } else if let data = mockData {
            completion(.success(data))
        }
    }

    func fetchWeather(forCoordinates coordinates: CLLocationCoordinate2D, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        fetchWeather(forCity: "Test City", completion: completion)
    }
}

class MockLocationManager: LocationManager {
    @Published var mockLocation: CLLocationCoordinate2D?
    @Published var mockLocationDenied: Bool = false

    override func requestLocation() {
        // Simulates a location update
        if let location = mockLocation {
            self.location = location
        } else {
            self.locationDenied = true
        }
    }
}
