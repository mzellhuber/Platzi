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
    var networkMonitor = NetworkMonitor()
    
    private var currentPage = 1
    private var isFetching = false

    func fetchMovies(ofType type: MovieType) {
        guard !isFetching else { return }
        
        if !networkMonitor.isConnected {
            fetchMoviesFromRealm()
        } else {
            isFetching = true
            Task {
                do {
                    let movieResults = try await NetworkService.shared.fetchMovies(ofType: type, page: currentPage)
                    
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
                            self.movies.append(contentsOf: unmanagedMovies)
                            self.isFetching = false
                        }
                    }
                    self.currentPage += 1

                } catch {
                    if let networkError = error as? NetworkError {
                        DispatchQueue.main.async {
                            self.error = networkError
                            self.isFetching = false
                        }
                    }
                }
            }
        }
    }

    func shouldPrefetch(item: Movie) -> Bool {
        guard !isFetching else { return false }
        return movies.last == item
    }
    
    func fetchMoviesFromRealm() {
        realmQueue.async {
            guard let realm = try? Realm() else { return }
            let moviesFromRealm = Array(realm.objects(Movie.self))
            
            let unmanagedMovies = moviesFromRealm.map { Movie(value: $0) }
            
            DispatchQueue.main.async {
                self.movies = unmanagedMovies
            }
        }
    }
}
