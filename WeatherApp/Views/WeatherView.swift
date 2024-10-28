//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Narinder Singh on 10/25/24.
//

import SwiftUI

struct WeatherInfoView: View {
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            if viewModel.isLoading {
                // Loading indicator with styling
                ProgressView("Fetching weather data...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .padding()
                    .foregroundColor(.gray)
            } else if let errorMessage = viewModel.errorMessage {
                // Error message with styling
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
                    .multilineTextAlignment(.center)
            } else {
                // Weather info display
                VStack(spacing: 8) {
                    Text(viewModel.city)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 5)
                    
                    Text(viewModel.temperature)
                        .font(.system(size: 40, weight: .medium))
                        .foregroundColor(.white)
                    
                    Text(viewModel.weatherDescription)
                        .font(.body)
                        .italic()
                        .foregroundColor(.white.opacity(0.8))
                }
                
                if let iconURL = viewModel.iconURL {
                    AsyncImage(url: iconURL) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 120)
                    } placeholder: {
                        ProgressView()
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.blue.opacity(0.7))
                .shadow(radius: 10)
        )
        .padding()
        .alert(isPresented: $viewModel.locationPermissionDenied) {
            Alert(
                title: Text("Location Access Denied"),
                message: Text("Please enable location access in Settings to get weather information for your current location."),
                primaryButton: .default(Text("Settings"), action: {
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsURL)
                    }
                }),
                secondaryButton: .cancel()
            )
        }
    }
}



