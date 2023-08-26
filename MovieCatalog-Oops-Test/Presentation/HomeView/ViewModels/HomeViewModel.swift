//
//  HomeViewModel.swift
//  MovieCatalog-Oops-Test
//
//  Created by Vladislav on 8/24/23.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject  {
    let realmService = RealmService.shared
    private var cancellables = Set<AnyCancellable>()
    
    @Published var movies: [Movie] = []
    
    init() {
        loadDataFromRealm()
        realmService.$movieUpdate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.loadDataFromRealm()
            }
            .store(in: &cancellables)
    }
    
    deinit {
        realmService.notificationToken?.invalidate()
    }

    func loadDataFromRealm() {
        movies = realmService.getAllMovies()
    }
    
    func getMovieCellModel() -> [MovieCellModel] {
        movies.map { MovieCellModel(id: $0.id, urlPoster: $0.urlPoster, title: $0.title) }
    }
    
    func deleteMovie(id: Int) {
        if let movie = movies.first(where: { $0.id == id }) {
            realmService.deleteMovie(movie: movie)
        }
    }
}
