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

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(viewModel.movies) { movie in
                        MovieRow(movie: movie)
                            .padding(.leading)
                            .background(Color.gray.opacity(0.5))
                            .padding(.top, 10)
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
