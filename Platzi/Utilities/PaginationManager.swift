//
//  PaginationManager.swift
//  Platzi
//
//  Created by Melissa Zellhuber on 04/10/23.
//

import Combine

class PaginationManager<PS: PaginationService> {
    private var service: PS
    private var contentType: MovieType
    private var cancellables = Set<AnyCancellable>()
    
    @Published var items: [PS.DataType] = []
    @Published var error: NetworkError?

    init(service: PS, ofType: MovieType) {
        self.service = service
        self.contentType = ofType
    }

    func fetchNextPage() {
        guard !service.isFetching else { return }
        service.isFetching = true
        service.currentPage += 1
        service.fetchPage(ofType: contentType, service.currentPage)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.error = error
                case .finished:
                    break
                }
                self?.service.isFetching = false
            }, receiveValue: { [weak self] newItems in
                self?.items.append(contentsOf: newItems)
            })
            .store(in: &cancellables)
    }
}
