//
//  Movie.swift
//  Platzi
//
//  Created by Melissa Zellhuber on 04/10/23.
//

import RealmSwift
import Foundation

class Movie: Object, ObjectKeyIdentifiable, Codable {
    @Persisted var backdropPath: String
    @Persisted(primaryKey: true) var id: Int
    @Persisted var originalTitle: String
    @Persisted var overview: String
    @Persisted var posterPath: String
    @Persisted var releaseDate: String
    @Persisted var title: String
    @Persisted var videoKey: String?
    @Persisted var imageData: Data?

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case id
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
    }

    required init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        backdropPath = try container.decode(String.self, forKey: .backdropPath)
        id = try container.decode(Int.self, forKey: .id)
        originalTitle = try container.decode(String.self, forKey: .originalTitle)
        overview = try container.decode(String.self, forKey: .overview)
        posterPath = try container.decode(String.self, forKey: .posterPath)
        releaseDate = try container.decode(String.self, forKey: .releaseDate)
        title = try container.decode(String.self, forKey: .title)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(backdropPath, forKey: .backdropPath)
        try container.encode(id, forKey: .id)
        try container.encode(originalTitle, forKey: .originalTitle)
        try container.encode(overview, forKey: .overview)
        try container.encode(posterPath, forKey: .posterPath)
        try container.encode(releaseDate, forKey: .releaseDate)
        try container.encode(title, forKey: .title)
    }

    required override init() {
        super.init()
    }
}
