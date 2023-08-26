//
//  DescriptionViewController.swift
//  MovieCatalog-Oops-Test
//
//  Created by Vladislav on 8/25/23.
//

import Foundation
import SwiftUI

// The application window that displays movie details
struct DescriptionViewController: View {
    
    // MARK: - Properties
    @ObservedObject var viewModel: DescriptionViewModel
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State private var scrollOffset = CGFloat.zero
    @State private var averageColor: Color = .gray
    private let posterSize = CGSize(width: 268, height: 390)
    
    // MARK: -  Initialization with a movie id
    init(id: Int) {
        self.viewModel = DescriptionViewModel(id: id)
    }
    
    // MARK: - Body
    var body: some View {
        //Gesture processing (swipe to go back)
        let drag = DragGesture()
            .onEnded {
                if $0.translation.width > UIScreen.main.bounds.width * 0.2 {
                    self.mode.wrappedValue.dismiss()
                }
            }
        
        GeometryReader { geometry in
            ZStack {
                backgroundCreation(geometry: geometry)
                scrollViewCreation()
            } .frame(width: geometry.size.width, height: geometry.size.height)
                .gesture(drag)
        } .statusBar(hidden: true)
    }
    
    // MARK: - Creating and configuring a View
    
    //Create and customize the background (picture and gradient)
    @ViewBuilder
    private func backgroundCreation(geometry: GeometryProxy) -> some View {
        AsyncImage(url: viewModel.movie?.urlBackdrop)  { image in
            image.resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: geometry.size.width)
                .clipped()
        } placeholder: {
            Color.white
        }
        .edgesIgnoringSafeArea(.all)
        
        LinearGradient(
            stops: [
                Gradient.Stop(color: averageColor.opacity(0.45), location: 0.00),
                Gradient.Stop(color: averageColor, location: 1.00),
            ],
            startPoint: UnitPoint(x: 0.5, y: 0),
            endPoint: UnitPoint(x: 0.5, y: 1)
        ).ignoresSafeArea()
    }
    
    //Creating and setting up a scorlview with content (poster, logo, text, etc.)
    @ViewBuilder
    private func scrollViewCreation() -> some View {
        ScrollView(showsIndicators: false)  {
            VStack(alignment: .center, spacing: 36) {
                AsyncImage(url: viewModel.movie?.urlPoster, transaction: Transaction(animation: .linear)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: posterSize.width, height: posterSize.height)
                            .clipped()
                            .onAppear {
                                self.setAverageColor(image: image)
                            }
                    case .failure(_):
                        Image(systemName: "photo")
                    @unknown default:
                        Text("Unknown error")
                    }
                }
                .frame(width: posterSize.width, height: posterSize.height)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.25), radius: 15, x: 0, y: 8)
                .padding(.horizontal, 62)
                
                AsyncImage(url: viewModel.movie?.urllogo) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 272, height: 124)
                        .clipped()
                } placeholder: {
                    ProgressView()
                }.padding(.horizontal, 60)
                
// TODO: - Add movie quality if needed.
                
                if let description = viewModel.movie?.descriptionMovie {
                    Text(description)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                }
            }
        }
    }
    
    // MARK: - Private methods
    
    //Setting the basic color to match the color of the loaded image
    @MainActor private func setAverageColor(image: Image) {
        if let imageUIColor = image.getUIImage(newSize: posterSize)?.averageColor {
            averageColor =  Color(imageUIColor)
        }
    }
}


