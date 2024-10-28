//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Narinder Singh on 10/25/24.
//

import Foundation
import CoreLocation
import Combine

class WeatherViewModel: ObservableObject {
    private let apiManager: WeatherAPIManagerProtocol
    private let locationManager: LocationManager
    var cancellables = Set<AnyCancellable>()

    @Published var weatherDescription: String = ""
    @Published var temperature: String = ""
    @Published var city: String = ""
    @Published var iconURL: URL?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var locationPermissionDenied: Bool = false

    init(apiManager: WeatherAPIManagerProtocol, locationManager: LocationManager) {
        self.apiManager = apiManager
        self.locationManager = locationManager
        setupLocationManager()
    }

    private func setupLocationManager() {
        //Checking if lastsearched city available, otherwise get currentlocation
        if let lastCity = UserDefaults.standard.string(forKey: "lastSearchedCity"), !lastCity.isEmpty {
            fetchWeather(byCityName: lastCity) // Fetch weather for the last city
        }else {
            locationManager.$location
                .compactMap { $0 } // Only get non-nil locations
                .sink { [weak self] coordinates in
                    self?.fetchWeather(byLocation: coordinates)
                }
                .store(in: &cancellables)
            
            locationManager.$locationDenied
                        .sink { [weak self] denied in
                            self?.locationPermissionDenied = denied
                        }
                        .store(in: &cancellables)

            requestLocation()
        }
    }
    
    // Request current location
    func requestLocation() {
        locationManager.requestLocation()
    }

    func fetchWeather(byCityName city: String) {
        isLoading = true
        apiManager.fetchWeather(forCity: city) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let data):
                    self?.updateWeatherData(with: data)
                    self?.errorMessage = nil
                case .failure(let error):
                    print("Failed to fetch weather: \(error.localizedDescription)")
                    self?.handleError(error)
                }
            }
        }
    }

    func fetchWeather(byLocation coordinates: CLLocationCoordinate2D) {
        isLoading = true
        apiManager.fetchWeather(forCoordinates: coordinates) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let data):
                    self?.updateWeatherData(with: data)
                    self?.errorMessage = nil
                case .failure(let error):
                    print("Failed to fetch weather: \(error.localizedDescription)")
                    self?.handleError(error)
                }
            }
        }
    }

    private func updateWeatherData(with data: WeatherData) {
        self.city = data.name
        self.temperature = "\(Int(data.main.temp - 273.15)) °C"
        self.weatherDescription = data.weather.first?.description.capitalized ?? "N/A"
        
        //to fetch last searched city
        UserDefaults.standard.set(city, forKey: "lastSearchedCity")

        if let icon = data.weather.first?.icon {
            self.iconURL = URL(string: "http://openweathermap.org/img/wn/\(icon)@2x.png")
        }
    }
    
    private func handleError(_ error: Error) {
           self.errorMessage = "Failed to fetch weather: \(error.localizedDescription)"
       }
}
