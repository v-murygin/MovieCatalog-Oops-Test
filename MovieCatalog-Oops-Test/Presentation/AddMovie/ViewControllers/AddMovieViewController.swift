//
//  AddMovieViewController.swift
//  MovieCatalog-Oops-Test
//
//  Created by Vladislav on 8/25/23.
//

import Foundation
import SwiftUI

//Screen for adding a new movie to the list
struct AddMovieViewController: View {
    
    // MARK: - Properties
    @ObservedObject var viewModel =  AddMovieViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // MARK: - View Elements
    var backButton : some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Text("Cancel")
            }
        }
    }
    
    var addButton: some View {
        Button(action: {
            if let movie = viewModel.movies.first?.movie {
                viewModel.addMovieData(movie: movie)
            }
        }) {
            Text("Add").bold()
        }
    }
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.movies, id: \.movie.id) { model in
                        MovieCardCell(model: model) {
                            viewModel.addMovieData(movie: model.movie)
                        }
                    }
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 26)
            }
            .navigationBarTitle("Add a Movie", displayMode: .large)
            .navigationBarItems(leading: backButton
                                , trailing: addButton)
            .onAppear {
                viewModel.fetchData()
            }
        }
    }
}

