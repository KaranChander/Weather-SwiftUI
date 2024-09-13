//
//  WeatherHomeView.swift
//  WeatherApp
//
//  Created by Karan . on 9/13/24.
//

import SwiftUI

struct WeatherHomeView: View {
    @ObservedObject var viewModel = WeatherHomeViewModel()
    var body: some View {
        VStack {
            HStack {
                TextField("Search Cities", text: $viewModel.searchText)
                    .submitLabel(.search)
                
                Image(systemName: "magnifyingglass")
            }
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 1).foregroundColor(Color.black)
                )
            .padding([.leading, .trailing, .top], 15)


          
            if !viewModel.cities.isEmpty {
                List {
                    ForEach(viewModel.cities) { location in
                        Text("\(location.name), \(location.state ?? "")")
                            .onTapGesture {
                                Task {
                                    await viewModel.fetchWeatherDetails(for: location)
                                }
                            }
                    }
                }
                .listStyle(.plain)
                .frame(height: 250)
                .cornerRadius(12)
                .padding(.horizontal, 16)
            } else {

                VStack(spacing: 5) {
                    if let weatherDetail = viewModel.weatherDetail {
                        Text(weatherDetail.name)
                            .foregroundColor(.black)
                            .font(.largeTitle)
                            .shadow(radius: 10)
//                            .padding()
                           
                        ZStack(alignment: .bottom) {
                            Image(systemName: viewModel.getWeatherIcon(icon: viewModel.weatherDetail?.weather.first?.icon ?? .clearSkyDay ))
                                            .renderingMode(.original)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 180, height: 180, alignment: .center)

                            Text(weatherDetail.main.displayTemp)
                                .foregroundColor(.black)
                                .font(.system(size: 60))
    //                            .padding()
                                .shadow(radius: 10)
                        }
                        
                        
                        Text(weatherDetail.weather.first?.main ?? "--")
                            .foregroundColor(.orange)
                            .font(.subheadline)
//                            .padding()
                            .shadow(radius: 10)
                        
                        HStack(spacing: 10) {
                            Text("H:\(weatherDetail.main.displayHighTemp)")
                                .foregroundColor(.black)
                                .font(.subheadline)
                            Text("L:\(weatherDetail.main.displayLowTemp)")
                                .foregroundColor(.black)
                                .font(.subheadline)
                        }
                    } else {
                        Text("No weather data available")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top, 100)
            }

            Spacer()
            
        }.background(Color.gray.opacity(0.15))
        .onAppear(perform: {
            Task {
                await viewModel.fetchLocationPermission()
            }
        })
      
    }

}

#Preview {
    WeatherHomeView()
}
