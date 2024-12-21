//
//  HomeViewController.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 19.12.24.
//

import UIKit

final class HomeViewController: BaseViewController {
    private lazy var popularMovieLabel: UILabel = {
        let label = ReusableLabel(labelText: "Popular Movies", labelColor: .white, labelSize: 48)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var popularMoviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleImageCollectionViewCell.self, forCellWithReuseIdentifier: "TitleImageCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.anchorSize(.init(width: 0, height: 160))
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private var collectionViewHeightConstraint: NSLayoutConstraint?
    private let viewModel: HomeViewModel?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.getNowPlayingMovies()
    }
    
    init(viewModel: HomeViewModel?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureView() {
        view.backgroundColor = .backgroundMain
        view.addSubViews(popularMovieLabel, popularMoviesCollectionView)
    }
    
    override func configureConstraint() {
        popularMovieLabel.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            padding: .init(top: 0, left: 0, bottom: 0, right: 0)
        )
        popularMovieLabel.centerXToSuperview()
        
        popularMoviesCollectionView.anchor(
            top: popularMovieLabel.bottomAnchor,
            leading: view.leadingAnchor,
//            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 4, left: 0, bottom: 0, right: 0)
        )
    }
    
    override func configureTargets() {
        
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleImageCollectionViewCell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 16) / 4
        return CGSize(width: width, height: collectionView.bounds.height)
    }
}
