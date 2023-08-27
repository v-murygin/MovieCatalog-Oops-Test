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
    @ObservedObject var viewModel = AddMovieViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // MARK: - View Elements
    // Back button - hides the pop-up window (not sure if it is needed. duplicates the swipe down)
    var backButton : some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Text("Cancel")
            }
        }
    }
    // Add button. Adds the first movie from the list. Not sure what you need, because there is a choice from the list.
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
            }.alert(isPresented: $viewModel.isError, content: {
                Alert(title: Text("Error"),
                      message: Text(viewModel.errorMessage ?? ""),
                      primaryButton: .default(Text("Repeat")) {
                          viewModel.resetErrorStatus()
                          viewModel.fetchData()
                      },
                      secondaryButton: .cancel(Text("Сlose")) {
                          viewModel.resetErrorStatus()
                          presentationMode.wrappedValue.dismiss()
                      }
                )
            })
            .navigationBarTitle("Add a Movie", displayMode: .large)
            .navigationBarItems(leading: backButton,
                                trailing: addButton)
            .onAppear {
                viewModel.fetchData()
            }
        }
    }
}

