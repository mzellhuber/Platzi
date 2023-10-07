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
                
                realmQueue.async {
                    guard let realm = try? Realm() else {
                        print("no realm")
                        return
                    }
                    try? realm.write {
                        realm.add(movieResults.results, update: .modified)
                    }
                    
                    let unmanagedMovies = movieResults.results.map { Movie(value: $0) }
                    DispatchQueue.main.async {
                        self.movies = unmanagedMovies
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
