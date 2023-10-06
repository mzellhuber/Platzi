//
//  MovieListViewModel.swift
//  Platzi
//
//  Created by Melissa Zellhuber on 04/10/23.
//

import Foundation
import RealmSwift

class MovieListViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var error: NetworkError?

    func fetchMovies(ofType type: MovieType) {
        Task {
            do {
                let movieResults = try await NetworkService.shared.fetchMovies(ofType: type)
                
                guard let realm = try? await Realm() else {
                    print("no realm")
                    return
                }

                DispatchQueue.main.async {
                    self.movies = movieResults.results
                    try? realm.write {
                        realm.add(self.movies, update: .modified)
                    }
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
