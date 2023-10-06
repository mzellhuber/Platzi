//
//  ContentView.swift
//  Platzi
//
//  Created by Melissa Zellhuber on 04/10/23.
//

import SwiftUI
import Combine

struct MovieListView: View {
    @StateObject private var viewModel = MovieListViewModel()
    @ObservedObject var networkMonitor = NetworkMonitor()

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.blue.opacity(0.05)]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    LazyVStack(spacing: 20) {
                        if !networkMonitor.isConnected {
                            OfflineBanner()
                        }
                        ForEach(viewModel.movies) { movie in
                            NavigationLink(destination: MovieDetailView(viewModel: MovieDetailsViewModel(movie: movie))) {
                                MovieRow(movie: movie)
                                    .padding(.leading)
                                    .background(Color.gray.opacity(0.8))
                                    .cornerRadius(15)
                                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                                    .padding(.top, 10)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
            .navigationBarTitle("Películas", displayMode: .large)
            .onAppear {
                viewModel.fetchMovies(ofType: .popular)
            }
        }
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView()
    }
}
