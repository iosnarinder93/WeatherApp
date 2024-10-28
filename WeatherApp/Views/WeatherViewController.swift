//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Narinder Singh on 10/25/24.
//

import UIKit
import SwiftUI

class WeatherViewController: UIViewController {
    private let viewModel = WeatherViewModel(apiManager: WeatherAPIManager(), locationManager: LocationManager())
    private let searchBar = UISearchBar()

    // Use State variables to hold weather data
    private var city: String = ""
    private var temperature: String = ""
    private var weatherDescription: String = ""
    private var iconURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.requestLocation()
    }

    private func setupUI() {
        title = "Weather App"
        view.backgroundColor = .white
        
        // Setup the search bar
        searchBar.placeholder = "Enter city name"
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        // Setup the weather info view
        let weatherInfoView = WeatherInfoView(viewModel: viewModel)
        let hostingController: UIHostingController<WeatherInfoView> = UIHostingController(rootView: weatherInfoView)
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.didMove(toParent: self)
        
        // Center the hosting controller's view within WeatherViewController's view
        NSLayoutConstraint.activate([
            hostingController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hostingController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            hostingController.view.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            hostingController.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
        
        hostingController.didMove(toParent: self)
    }
}

// Extend WeatherViewController to conform to UISearchBarDelegate
extension WeatherViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let city = searchBar.text, !city.isEmpty else { return }
        viewModel.fetchWeather(byCityName: city)
        searchBar.resignFirstResponder() // Dismiss the keyboard
    }
}
