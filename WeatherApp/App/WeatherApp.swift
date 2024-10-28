//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Narinder Singh on 10/25/24.
//

import SwiftUI

@main
struct WeatherApp: App {
        private let coordinator = MainCoordinator()
        var body: some Scene {
            WindowGroup {
                // Embed the coordinator's navigation controller in SwiftUI
                AppRootView(coordinator: coordinator)
                    .onAppear {
                        coordinator.start()
                    }
            }
        }
}
