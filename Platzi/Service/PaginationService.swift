//
//  PaginationService.swift
//  Platzi
//
//  Created by Melissa Zellhuber on 04/10/23.
//

import Combine

protocol PaginationService {
    associatedtype DataType
    var isFetching: Bool { get set }
    var currentPage: Int { get set }
    func fetchPage(ofType type: MovieType, _ page: Int) -> AnyPublisher<[DataType], NetworkError>
}
