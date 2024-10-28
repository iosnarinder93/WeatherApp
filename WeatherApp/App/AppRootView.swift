//
//  AppRootView.swift
//  WeatherApp
//
//  Created by Narinder Singh on 10/25/24.
//

import SwiftUI
import UIKit

struct AppRootView: UIViewControllerRepresentable {
    let coordinator: MainCoordinator

    func makeUIViewController(context: Context) -> UINavigationController {
        let navigationController = UINavigationController()
        coordinator.navigationController = navigationController
        return navigationController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}
