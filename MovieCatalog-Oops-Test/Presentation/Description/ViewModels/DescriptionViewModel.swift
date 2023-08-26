//
//  DescriptionViewModel.swift
//  MovieCatalog-Oops-Test
//
//  Created by Vladislav on 8/25/23.
//

import Foundation

//View Model for Description screen
class DescriptionViewModel: ObservableObject {
    // MARK: - Properties
    let realmService = RealmService.shared
    private let id: Int
    @Published var movie: Movie?
    
    // MARK: -  Initialization with a movie id
    init(id: Int) {
        self.id = id
        getDataFromRealm()
    }

    // MARK: - Functions
//    Finding and getting the desired movie from the database
    func getDataFromRealm() {
        movie = realmService.getAllMovies().first { $0.id == id }
    }
}
