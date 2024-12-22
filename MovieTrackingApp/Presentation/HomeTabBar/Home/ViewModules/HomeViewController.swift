//
//  HomeViewController.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 19.12.24.
//

import UIKit

enum MovieListType {
    case nowPlaying
    case popular
    case topRated
    case upcoming
}

final class HomeViewController: BaseViewController {
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .black
        view.tintColor = .black
        view.hidesWhenStopped = true
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nowPlayingMovieLabel: UILabel = {
        let label = ReusableLabel(labelText: "Now Playing", labelColor: .white, labelFont: "NexaRegular", labelSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nowPlayingSeeAllButton: UIButton = {
        let button = ReusableButton(title: "See All", onAction: nowPlayingSeeAllButtonClicked, bgColor: .clear, titleColor: .primaryHighlight)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var nowPlayingMoviesLabelStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nowPlayingMovieLabel, nowPlayingSeeAllButton])
        stack.axis = .horizontal
        stack.backgroundColor = .clear
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var nowPlayingMoviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleImageCollectionViewCell.self, forCellWithReuseIdentifier: "TitleImageCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.anchorSize(.init(width: 0, height: 228))
        return collectionView
    }()
    
    private lazy var nowPlayingMoviesStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nowPlayingMoviesLabelStack, nowPlayingMoviesCollectionView])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.backgroundColor = .clear
        stack.alignment = .fill
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var popularMovieLabel: UILabel = {
        let label = ReusableLabel(labelText: "Popular Movies", labelColor: .white, labelFont: "NexaRegular", labelSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var popularMoviesSeeAllButton: UIButton = {
        let button = ReusableButton(title: "See All", onAction: popularMoviesSeeAllButtonClicked, bgColor: .clear, titleColor: .primaryHighlight)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var popularMoviesLabelStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [popularMovieLabel, popularMoviesSeeAllButton])
        stack.axis = .horizontal
        stack.backgroundColor = .clear
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var popularMoviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleImageCollectionViewCell.self, forCellWithReuseIdentifier: "TitleImageCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.anchorSize(.init(width: 0, height: 228))
        return collectionView
    }()
    
    private lazy var popularMoviesStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [popularMoviesLabelStack, popularMoviesCollectionView])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var topRatedMovieLabel: UILabel = {
        let label = ReusableLabel(labelText: "Top Rated Movies", labelColor: .white, labelFont: "NexaRegular", labelSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var topRatedMoviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleImageCollectionViewCell.self, forCellWithReuseIdentifier: "TitleImageCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.anchorSize(.init(width: 0, height: 228))
        return collectionView
    }()
    
    private lazy var topRatedMoviesStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [topRatedMovieLabel, topRatedMoviesCollectionView])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.addSubview(scrollStack)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var scrollStack: UIStackView = {
        let scrollStack = UIStackView(arrangedSubviews: [nowPlayingMoviesStack, popularMoviesStack, topRatedMoviesStack])
        scrollStack.axis = .vertical
        scrollStack.spacing = 16
        scrollStack.backgroundColor = .clear
        scrollStack.translatesAutoresizingMaskIntoConstraints = false
        return scrollStack
    }()
    
    private let viewModel: HomeViewModel?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        configureNavigationBar()
        
        viewModel?.getNowPlayingMovies()
        viewModel?.getPopularMovies()
        viewModel?.getTopRatedMovies()
    }
    
    override func configureView() {
        view.backgroundColor = .backgroundMain
        view.addSubViews(scrollView)
        view.bringSubviewToFront(loadingView)
    }
    
    override func configureConstraint() {
        loadingView.centerXToSuperview()
        loadingView.centerYToSuperview()
        
        scrollView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            trailing: view.safeAreaLayoutGuide.trailingAnchor,
            padding: .init(all: 0)
        )
        
        scrollStack.anchor(
            top: scrollView.topAnchor,
            leading: scrollView.leadingAnchor,
            bottom: scrollView.bottomAnchor,
            trailing: scrollView.trailingAnchor,
            padding: .init(all: 0)
        )
        scrollStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        nowPlayingMoviesStack.anchor(
            leading: scrollStack.leadingAnchor,
            trailing: scrollStack.trailingAnchor,
            padding: .init(all: .zero)
        )
        nowPlayingMoviesLabelStack.anchor(
            top: nowPlayingMoviesStack.topAnchor,
            leading: nowPlayingMoviesStack.leadingAnchor,
            trailing: nowPlayingMoviesStack.trailingAnchor,
            padding: .init(top: 0, left: 4, bottom: 0, right: 4)
        )
        nowPlayingMoviesCollectionView.anchor(
            top: nowPlayingMoviesLabelStack.bottomAnchor,
            leading: nowPlayingMoviesStack.leadingAnchor,
            trailing: nowPlayingMoviesStack.trailingAnchor,
            padding: .init(all: .zero)
        )
        
        popularMoviesStack.anchor(
            leading: scrollStack.leadingAnchor,
            trailing: scrollStack.trailingAnchor,
            padding: .init(all: .zero)
        )
        popularMoviesLabelStack.anchor(
            top: popularMoviesStack.topAnchor,
            leading: popularMoviesStack.leadingAnchor,
            trailing: popularMoviesStack.trailingAnchor,
            padding: .init(top: 0, left: 4, bottom: 0, right: 4)
        )
        popularMoviesCollectionView.anchor(
            top: popularMoviesLabelStack.bottomAnchor,
            leading: popularMoviesStack.leadingAnchor,
            padding: .init(all: .zero)
        )
        
        topRatedMoviesStack.anchor(
            leading: scrollStack.leadingAnchor,
            trailing: scrollStack.trailingAnchor,
            padding: .init(all: .zero)
        )
        topRatedMovieLabel.anchor(
            top: topRatedMoviesStack.topAnchor,
            leading: topRatedMoviesStack.leadingAnchor,
            padding: .init(top: 0, left: 4, bottom: 0, right: 0)
        )
        topRatedMoviesCollectionView.anchor(
            top: topRatedMovieLabel.bottomAnchor,
            leading: topRatedMoviesStack.leadingAnchor,
            padding: .init(all: .zero)
        )
    }
    
    override func configureTargets() {
        
    }
    
    fileprivate func configureNavigationBar() {
        let navgationView = UIView()
        navgationView.translatesAutoresizingMaskIntoConstraints = false
        let label = UILabel()
        label.text = "Movies"
        label.sizeToFit()
        label.textAlignment = .center
        label.font = UIFont(name: "Nexa-Bold", size: 20)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
       
        navgationView.addSubview(label)
        label.centerXToView(to: navgationView)
        label.centerToYView(to: navgationView)

        navigationItem.titleView = navgationView
    }
    
    init(viewModel: HomeViewModel?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configureViewModel() {
        viewModel?.requestCallback = { [weak self] state in
            guard let self = self else {return}
            switch state {
            case .loading:
                DispatchQueue.main.async {
                    self.loadingView.startAnimating()
                }
            case .loaded:
                DispatchQueue.main.async {
                    self.loadingView.stopAnimating()
                }
            case .success:
                DispatchQueue.main.async {
                    self.nowPlayingMoviesCollectionView.reloadData()
                    self.popularMoviesCollectionView.reloadData()
                    self.topRatedMoviesCollectionView.reloadData()
                }
            case .error(message: let message):
                showMessage(title: message)
            }
        }
    }
    
    @objc fileprivate func nowPlayingSeeAllButtonClicked() {
        viewModel?.showAllItems(listType: .nowPlaying)
    }
    
    @objc fileprivate func popularMoviesSeeAllButtonClicked() {
        viewModel?.showAllItems(listType: .popular)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == nowPlayingMoviesCollectionView {
            return viewModel?.getNowPlayingItems() ?? 0
        }
        else if collectionView == popularMoviesCollectionView {
            return viewModel?.getPopularMovieItems() ?? 0
        }
        else if collectionView == topRatedMoviesCollectionView {
            return viewModel?.getTopRatedItems() ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleImageCollectionViewCell", for: indexPath) as? TitleImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        if collectionView == nowPlayingMoviesCollectionView {
            let item = viewModel?.getNowPlayingProtocol(index: indexPath.row)
            cell.configureCell(model: item)
        }
        else if collectionView == popularMoviesCollectionView {
            let item = viewModel?.getPopularMovieProtocol(index: indexPath.row)
            cell.configureCell(model: item)
        }
        else if collectionView == topRatedMoviesCollectionView {
            let item = viewModel?.getTopRatedProtocol(index: indexPath.row)
            cell.configureCell(model: item)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.showMovieDetail()
    }
}
