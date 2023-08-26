//
//  GlassText.swift
//  MovieCatalog-Oops-Test
//
//  Created by Vladislav on 8/25/23.
//

import Foundation
import SwiftUI

struct GlassText: View {
    var title: String

    var body: some View {
        Text(title)
            .font(.body)
            .foregroundColor(.white)
            .padding(8) 
            .background(Color.black.opacity(0.6))
            .cornerRadius(10)
    }
}
