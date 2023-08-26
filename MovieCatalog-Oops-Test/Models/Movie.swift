//
//  File.swift
//  MovieCatalog-Oops-Test
//
//  Created by Vladislav on 8/24/23.
//

import Foundation
import UIKit

struct Movie: Hashable {
    let id: Int
    let title: String
    let urlPoster: URL?
    let urlBackdrop: URL?
    let urllogo: URL?
    let descriptionMovie: String
    let showMovieQuality: Bool
}

extension Movie {
    func toMovieRealm() -> MovieRealm {
        let movieRealm = MovieRealm()
        movieRealm.id = id
        movieRealm.title = title
        movieRealm.urlBackdrop = urlBackdrop?.absoluteString
        movieRealm.urlPoster = urlPoster?.absoluteString
        movieRealm.urllogo = urllogo?.absoluteString
        movieRealm.descriptionMovie = descriptionMovie
        movieRealm.showMovieQuality = showMovieQuality
        return movieRealm
    }
}

