//
//  HomeViewController.swift
//  MovieCatalog-Oops-Test
//
//  Created by Vladislav on 8/24/23.
//

import UIKit
import SwiftUI
import Combine

class HomeViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, MovieCellModel>

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 115, height: 210)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
        
    private var dataSource: DataSource!
    private var viewModel = HomeViewModel()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        viewModel.$movies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateData()
            }
            .store(in: &cancellables)
    }

    private func configure(){
        title = "Library"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addItem))
        configureCollectionView()
        configureDataSource()
        
        addLongPressGesture()
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func addLongPressGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(_:)))
        self.collectionView.addGestureRecognizer(longPressGesture)
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, MovieCellModel> { cell, indexPath, item in
                  cell.contentConfiguration = UIHostingConfiguration {
                      MovieCell(id: item.id, imageUrl: item.urlPoster)
                  }
              }
         dataSource = DataSource( collectionView: collectionView, cellProvider: { (collectionView, indexPath, movie) -> UICollectionViewCell? in
             let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: movie)
             return cell
         })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, MovieCellModel>()
        snapshot.appendSections([.library])
        snapshot.appendItems(viewModel.getMovieCellModel())
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private func updateData() {
        viewModel.loadDataFromRealm()
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, MovieCellModel>()
        snapshot.appendSections([.library])
        snapshot.appendItems(viewModel.getMovieCellModel())
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    @objc private func addItem() {
        let addVC = AddMovieViewController()
        let hostingController = UIHostingController(rootView: addVC)
        self.present(hostingController, animated: true)
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state != .ended { return }

        let point = gesture.location(in: self.collectionView)
        if let indexPath = self.collectionView.indexPathForItem(at: point), let movie = dataSource.itemIdentifier(for: indexPath) {
            let alertController = UIAlertController(title: "Delete ''\(movie.title!)'' ?", message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [weak self] _ in
                self?.viewModel.deleteMovie(id: movie.id)
            }))
            alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = dataSource.itemIdentifier(for: indexPath) else { return }
        let detailVC = DescriptionViewController(id: movie.id).navigationBarHidden(true)
        let hostingController = UIHostingController(rootView: detailVC)
        self.navigationController?.pushViewController(hostingController, animated: true)
    }
}
