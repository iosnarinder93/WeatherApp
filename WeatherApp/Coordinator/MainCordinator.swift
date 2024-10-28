//
//  MainCordinator.swift
//  WeatherApp
//
//  Created by Narinder Singh on 10/25/24.
//

import UIKit

class MainCoordinator {
    var navigationController: UINavigationController?

    func start() {
        let weatherVC = WeatherViewController()
        navigationController?.pushViewController(weatherVC, animated: true)
    }
}
