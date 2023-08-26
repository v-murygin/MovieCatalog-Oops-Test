//
//  MovieCell.swift
//  MovieCatalog-Oops-Test
//
//  Created by Vladislav on 8/24/23.
//

import Foundation

struct MovieCellModel: Hashable {
    let id: Int
    let urlPoster: URL?
    let title: String?
}
