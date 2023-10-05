//
//  MovieDetailsViewModel.swift
//  Platzi
//
//  Created by Melissa Zellhuber on 05/10/23.
//

import Foundation

class MovieDetailsViewModel: ObservableObject {
    var movie: Movie
    private var networkService: NetworkService

    @Published var videoKey: String?

    init(movie: Movie, networkService: NetworkService = NetworkService.shared) {
        self.movie = movie
        self.networkService = networkService
    }

    func fetchMovieVideo() {
        Task {
            do {
                if let video = try await networkService.fetchMovieVideo(for: movie.id) {
                    DispatchQueue.main.async {
                        self.videoKey = video.key
                    }
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }

}
