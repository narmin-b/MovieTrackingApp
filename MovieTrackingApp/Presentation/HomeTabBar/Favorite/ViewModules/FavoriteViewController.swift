//
//  FavoriteViewController.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 20.12.24.
//

import UIKit

class FavoriteViewController: BaseViewController {
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .white
        view.tintColor = .white
        view.hidesWhenStopped = true
        view.backgroundColor = .backgroundMain
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var allMoviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 4
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 4, right: 8)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(RatedCollectionViewCell.self, forCellWithReuseIdentifier: "RatedCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var segmentView: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Movies", "Tv Shows"])
        segment.selectedSegmentIndex = 0
        segment.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        segment.anchorSize(.init(width: 0, height: 48))
        segment.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "NexaRegular", size: 16) ?? UIFont.systemFont(ofSize: 16)
        ], for: .normal)
        
        segment.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont(name: "Nexa-Bold", size: 24) ?? UIFont.boldSystemFont(ofSize: 16)
        ], for: .selected)
        
        segment.selectedSegmentTintColor = .secondaryHighlight
        segment.addTarget(self, action: #selector(didClickSegment), for: .valueChanged)
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    
    private let viewModel: FavoriteViewModel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel?.getRatedMovies()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
    }
    
    init(viewModel: FavoriteViewModel?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        viewModel?.requestCallback = nil
    }
    
    override func configureView() {
        configureNavigationBar()
        
        view.backgroundColor = .backgroundMain
        view.addSubViews(loadingView, segmentView, allMoviesCollectionView)
        view.bringSubviewToFront(loadingView)
    }
    
    override func configureConstraint() {
        loadingView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(all: 0)
        )
        
        segmentView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 4, bottom: 0, right: -4)
        )
        
        allMoviesCollectionView.anchor(
            top: segmentView.bottomAnchor,
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 4, left: 0, bottom: 0, right: 0)
        )
    }
    
    fileprivate func configureNavigationBar() {
        navigationItem.configureNavigationBar(text: "Rated Titles")
        navigationController?.navigationBar.tintColor = .primaryHighlight
    }
    
    fileprivate func configureViewModel() {
        viewModel?.requestCallback = { [weak self] state in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch state {
                case .loading:
                    self.loadingView.startAnimating()
                case .loaded:
                    self.loadingView.stopAnimating()
                case .success:
                    self.allMoviesCollectionView.reloadData()
                case .error(message: let message):
                    self.showMessage(title: message)
                }
            }
        }
    }
    
    @objc fileprivate func didClickSegment() {
        switch segmentView.selectedSegmentIndex {
        case 0: viewModel?.getRatedMovies()
        case 1: viewModel?.getRatedTvShows()
        default: return
        }
    }
}


extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch segmentView.selectedSegmentIndex {
        case 0: return viewModel?.getRatedMoviesItems() ?? 0
        case 1: return viewModel?.getRatedTvShowItems() ?? 0
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RatedCollectionViewCell", for: indexPath) as? RatedCollectionViewCell else {
            return UICollectionViewCell()
        }
        switch segmentView.selectedSegmentIndex {
        case 0:
            let item = viewModel?.getRatedMoviesItemsProtocol(index: indexPath.row)
            cell.configureCell(model: item)
        case 1:
            let item = viewModel?.getRatedTvShowItemsProtocol(index: indexPath.row)
            cell.configureCell(model: item)
        default: return UICollectionViewCell()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 8, height: (collectionView.bounds.height - 20)/5)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath) {
            switch segmentView.selectedSegmentIndex {
            case 0:
                guard let item = viewModel?.getItem(index: indexPath.item, mediaType: .movie) else { return }
                viewModel?.showMovieDetail(mediaType: .movie, id: item)
            case 1:
                guard let item = viewModel?.getItem(index: indexPath.item, mediaType: .tvShow) else { return }
                viewModel?.showMovieDetail(mediaType: .tvShow, id: item)
            default: return
            }
        }
}
