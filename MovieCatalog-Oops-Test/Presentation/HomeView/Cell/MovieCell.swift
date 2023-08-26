//
//  MovieCell.swift
//  MovieCatalog-Oops-Test
//
//  Created by Vladislav on 8/24/23.
//

import Foundation

import SwiftUI
import UIKit


struct MovieCell: View {
    @State private var averageColor: Color = .gray
    @State private var imageLoaded: Bool = false
    
    let id: Int
    let imageUrl: URL?
    
    private let imageSize = CGSize(width: 105, height: 186)
    
    var body: some View {
        ZStack {
            Rectangle()
              .foregroundColor(averageColor)
              .frame(width: imageSize.width, height: imageSize.height)
              .border(averageColor.opacity(0.5), width: 2)
              .cornerRadius(14)
              .transformEffect(CGAffineTransform(a: 1.0, b: -0.09, c: 0.0, d: 1.0, tx: 0.0, ty: 0.0))
              .offset(x: -5)

            AsyncImage(url: imageUrl) { phase in
                    switch phase {
                    case .empty:
                        ProgressView("Loading...")
                    case .success(let image):
                        image.resizable()
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: imageSize.width, height: imageSize.height)
                            .clipped()
                            .opacity(self.imageLoaded ? 1 : 0)
                            .animation(.easeInOut, value: self.imageLoaded)
                            .onAppear {
                                self.setAverageColor(image: image)
                                self.imageLoaded = true
                            }
                    case .failure(_):
                        Image(systemName: "photo")
                    @unknown default:
                        Text("Unknown error")
                    }
                }.cornerRadius(12)
                 .transformEffect(CGAffineTransform(a: 1.0, b: -0.09, c: 0.0, d: 1.0, tx: 0.0, ty: 0.0))
                 .shadow(color: .black.opacity(0.25), radius: 7.5, x: 0, y: 8)
        }.frame(width: 110, height: 205)
    }
    
    @MainActor private func setAverageColor(image: Image) {
        if let imageUIColor = image.getUIImage(newSize: imageSize)?.averageColor {
            averageColor =  Color(imageUIColor)
        }
    }
}
