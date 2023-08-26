//
//  MovieCardCell.swift
//  MovieCatalog-Oops-Test
//
//  Created by Vladislav on 8/25/23.
//

import Foundation
import SwiftUI

// Movie сell
struct MovieCardCell: View {
    // MARK: - Properties
    @State var model: MovieCardCellModel
    private let frameSize: CGSize = CGSize(width: 342, height: 172)
    var onTap: () -> Void
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: model.movie.urlBackdrop) { image in
                image.resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
                    .foregroundColor(.clear)
            }
            .frame(width: frameSize.width, height: frameSize.height)
            .background(.thinMaterial)
            .clipped()
            .cornerRadius(20)
                        
            GlassText(title: model.movie.title)
                .frame(maxHeight: 30)
                .padding(8)
            
            // marks the cell as "used"
            if model.isTapped {
                Rectangle()
                    .foregroundColor(.white.opacity(0.5))
                    .cornerRadius(20)
                    .frame(width: frameSize.width, height: frameSize.height)
            }
        }
        .scaleEffect(model.isTapped ? 0.97 : 1.0)
        .animation(.easeIn, value: model.isTapped)
        .onTapGesture {
            model.isTapped = true
            onTap()
        }
    }
}
