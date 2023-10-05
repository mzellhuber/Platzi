//
//  MovieListViewModel.swift
//  Platzi
//
//  Created by Melissa Zellhuber on 04/10/23.
//

import Combine
import Foundation

class MovieListViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var error: NetworkError?

    private var cancellables = Set<AnyCancellable>()

    func fetchMovies(ofType type: MovieType) {
        Task {
            do {
                let movieResults = try await NetworkService.shared.fetchMovies(ofType: type)
                DispatchQueue.main.async {
                    self.movies = movieResults.results
                }
            } catch {
                if let networkError = error as? NetworkError {
                    DispatchQueue.main.async {
                        self.error = networkError
                    }
                }
            }
        }
    }
}
