//
//  WeatherViewModel.swift
//  WeatherAppTests
//
//  Created by Kulvir Singh on 10/25/24.
//

import XCTest
import CoreLocation
@testable import WeatherApp

class WeatherViewModelTests: XCTestCase {
    var viewModel: WeatherViewModel!
    var mockAPIManager: MockWeatherAPIManager!
    var mockLocationManager: MockLocationManager!

    override func setUp() {
        super.setUp()
        
        // Initialize mocks
        mockAPIManager = MockWeatherAPIManager()
        mockLocationManager = MockLocationManager()
        
        // Set initial mock data
        let weatherData = WeatherData(
            name: "Test City",
            main: Main(temp: 300.15, humidity: 14), // example temperature
            weather: [Weather(description: "Clear sky", icon: "01d")]
        )
        mockAPIManager.mockData = weatherData // Set mock data
        
        // Initialize view model with mocks
        viewModel = WeatherViewModel(apiManager: mockAPIManager, locationManager: mockLocationManager)
    }

    override func tearDown() {
        viewModel = nil
        mockAPIManager = nil
        mockLocationManager = nil
        super.tearDown()
    }

    func testFetchWeatherByCityName_Success() {
        // Arrange
        let expectedCity = "Test City"
        
        // Act
        viewModel.fetchWeather(byCityName: expectedCity)
        
        // Assert
        XCTAssertEqual(viewModel.city, expectedCity)
        XCTAssertEqual(viewModel.temperature, "27 °C") //STATIC TO MATCH LATER
        XCTAssertEqual(viewModel.weatherDescription, "Clear sky")
        XCTAssertNotNil(viewModel.iconURL)
    }

    func testFetchWeatherByCityName_Failure() {
        // Arrange
        mockAPIManager.shouldReturnError = true
        
        // Act
        viewModel.fetchWeather(byCityName: "Test City")
        
        // Assert
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, "Failed to fetch weather: TestError")
    }

    func testFetchWeatherByLocation_Success() {
        // Arrange
        mockLocationManager.mockLocation = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194) // Example coordinates
        
        // Act
        viewModel.requestLocation()
        
        // Assert
        XCTAssertEqual(viewModel.city, "Test City")
        XCTAssertEqual(viewModel.temperature, "27 °C")
        XCTAssertEqual(viewModel.weatherDescription, "Clear sky")
        XCTAssertNil(viewModel.errorMessage)
    }

    func testLoadingState_WhenFetchingWeather() {
        // Arrange
        let expectation = XCTestExpectation(description: "Loading state changes")
        
        // Act
        viewModel.$isLoading
            .dropFirst() // Skip initial value
            .sink { isLoading in
                if isLoading {
                    XCTAssertTrue(isLoading)
                } else {
                    XCTAssertFalse(isLoading)
                    expectation.fulfill()
                }
            }
            .store(in: &viewModel.cancellables)
        
        viewModel.fetchWeather(byCityName: "Test City")
        
        // Assert
        wait(for: [expectation], timeout: 2.0)
    }
}

