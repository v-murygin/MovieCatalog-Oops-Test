//
//  MovieRealm.swift
//  MovieCatalog-Oops-Test
//
//  Created by Vladislav on 8/25/23.
//

import Foundation
import RealmSwift

class MovieRealm: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var urlPoster: String? = nil
    @objc dynamic var urlBackdrop: String? = nil
    @objc dynamic var urllogo: String? = nil
    @objc dynamic var descriptionMovie: String = ""
    @objc dynamic var showMovieQuality: Bool = false
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension MovieRealm {
    func toMovie() -> Movie {
        return Movie(id: id,
                     title: title,
                     urlPoster: URL(string: urlPoster ?? ""),
                     urlBackdrop: URL(string: urlBackdrop ?? ""),
                     urllogo: URL(string: urllogo ?? ""),
                     descriptionMovie: descriptionMovie,
                     showMovieQuality: showMovieQuality)
    }
}
