//
//  MovieListViewModelTests.swift
//  PlatziTests
//
//  Created by Melissa Zellhuber on 07/10/23.
//

@testable import Platzi
import XCTest
import RealmSwift

class MovieListViewModelTests: XCTestCase {

    var viewModel: MovieListViewModel!
    var mockNetworkService: MockNetworkService!
    var realm: Realm!
    
    override func setUp() {
        super.setUp()
        
        mockNetworkService = MockNetworkService()
        viewModel = MovieListViewModel()
        realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "TestRealm"))
    }

    override func tearDown() {
        viewModel = nil
        mockNetworkService = nil
        try! realm.write {
            realm.deleteAll()
        }
        super.tearDown()
    }
    
    func testAddMovie() {
        let mockMovie = Movie()
        viewModel.movies = [mockMovie]
        XCTAssertEqual(viewModel.movies.count, 1)
        XCTAssertEqual(viewModel.movies[0], mockMovie)
    }
    
    func testViewModelInitialState() {
        let viewModel = MovieListViewModel()
        
        XCTAssertTrue(viewModel.movies.isEmpty)
        XCTAssertNil(viewModel.error)
    }
    
    func testRealmDatabaseIntegration() async {
        let mockMovies = APIResult(page: 1, results: [Movie()], totalPages: 1, totalResults: 10)
        mockNetworkService.mockMoviesResult = mockMovies

        viewModel.fetchMovies(ofType: .popular)
        
        DispatchQueue.main.async {
            let storedMovies = self.realm.objects(Movie.self)
            XCTAssertEqual(storedMovies.count, mockMovies.results.count)
        }
    }
}

class MockNetworkService: NetworkService {
    
    var mockMoviesResult: APIResult<Movie>!
    var shouldThrowError = false

    init(mockMoviesResult: APIResult<Movie>? = nil, shouldThrowError: Bool = false) {
        self.mockMoviesResult = mockMoviesResult
        self.shouldThrowError = shouldThrowError
        super.init()
    }

    override func fetchMovies(ofType type: MovieType, page: Int = 1) async throws -> APIResult<Movie> {
        if shouldThrowError {
            throw NetworkError.networkError(URLError(.badServerResponse))
        }
        return mockMoviesResult
    }
}
