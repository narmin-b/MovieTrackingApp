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

enum TvShowListType {
    case airingToday
    case onTheAir
    case topRated
    case popular
}

enum HomeListType {
    case movie(MovieListType)
    case tvShow(TvShowListType)
}

final class HomeViewController: BaseViewController {
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .white
        view.tintColor = .white
        view.hidesWhenStopped = true
        view.backgroundColor = .backgroundMain
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var segmentView: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Movies", "Tv Shows"])
        segment.selectedSegmentIndex = 0
//        segment.layer.cornerRadius = 5.0
//        segment.backgroundColor = .clear
//        segment.tintColor = .clear
//        segment.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
//        segment.setBackgroundImage(UIImage(), for: .selected, barMetrics: .default)
        segment.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        segment.anchorSize(.init(width: 0, height: 52))
        segment.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "NexaRegular", size: 20) ?? UIFont.systemFont(ofSize: 16)
        ], for: .normal)
        
        segment.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont(name: "Nexa-Bold", size: 28) ?? UIFont.boldSystemFont(ofSize: 16)
        ], for: .selected)
        
        segment.selectedSegmentTintColor = .secondaryHighlight
        segment.addTarget(self, action: #selector(changeSegment), for: .valueChanged)
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()

    private lazy var nowPlayingMovieLabel: UILabel = {
        let label = ReusableLabel(labelText: "Now Playing", labelColor: .white, labelFont: "NexaRegular", labelSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nowPlayingSeeAllButton: UIButton = {
        let button = ReusableButton(title: "See All", onAction: nowPlayingSeeAllButtonClicked, bgColor: .clear, titleColor: .primaryHighlight)
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "chevron.right")
        config.imagePlacement = .trailing
        config.imagePadding = 8
        config.baseForegroundColor = .primaryHighlight
        button.configuration = config
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
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "chevron.right")
        config.imagePlacement = .trailing
        config.imagePadding = 8
        config.baseForegroundColor = .primaryHighlight
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var popularMoviesLabelStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [popularMovieLabel, popularMoviesSeeAllButton])
        stack.axis = .horizontal
        stack.backgroundColor = .clear
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 4
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
    
    private lazy var topRatedMoviesSeeAllButton: UIButton = {
        let button = ReusableButton(title: "See All", onAction: topRatedMoviesSeeAllButtonClicked, bgColor: .clear, titleColor: .primaryHighlight)
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "chevron.right")
        config.imagePlacement = .trailing
        config.imagePadding = 8
        config.baseForegroundColor = .primaryHighlight
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var topRatedMoviesLabelStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [topRatedMovieLabel, topRatedMoviesSeeAllButton])
        stack.axis = .horizontal
        stack.backgroundColor = .clear
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
        let stack = UIStackView(arrangedSubviews: [topRatedMoviesLabelStack, topRatedMoviesCollectionView])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var upcomingMovieLabel: UILabel = {
        let label = ReusableLabel(labelText: "Upcoming Movies", labelColor: .white, labelFont: "NexaRegular", labelSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var upcomingMoviesSeeAllButton: UIButton = {
        let button = ReusableButton(title: "See All", onAction: upcomingMoviesSeeAllButtonClicked, bgColor: .clear, titleColor: .primaryHighlight)
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "chevron.right")
        config.imagePlacement = .trailing
        config.imagePadding = 8
        config.baseForegroundColor = .primaryHighlight
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var upcomingMoviesLabelStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [upcomingMovieLabel, upcomingMoviesSeeAllButton])
        stack.axis = .horizontal
        stack.backgroundColor = .clear
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var upcomingMoviesCollectionView: UICollectionView = {
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
    
    private lazy var upcomingMoviesStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [upcomingMoviesLabelStack, upcomingMoviesCollectionView])
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
        let scrollStack = UIStackView(arrangedSubviews: [nowPlayingMoviesStack, popularMoviesStack, topRatedMoviesStack, upcomingMoviesStack])
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
        
        viewModel?.getNowPlayingMovies()
        viewModel?.getPopularMovies()
        viewModel?.getTopRatedMovies()
        viewModel?.getUpcomingMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func configureView() {
        view.backgroundColor = .backgroundMain
        view.addSubViews(loadingView, segmentView, scrollView)
        view.bringSubviewToFront(loadingView)
        nowPlayingMovieLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        popularMovieLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        topRatedMovieLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        upcomingMovieLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)

        nowPlayingSeeAllButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        popularMoviesSeeAllButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        topRatedMoviesSeeAllButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        upcomingMoviesSeeAllButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    override func configureConstraint() {
        loadingView.anchor(
            top: segmentView.bottomAnchor,
            leading: view.leadingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(all: 0)
        )
        
        segmentView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: .init(all: .zero)
        )
        
        scrollView.anchor(
            top: segmentView.bottomAnchor,
            leading: view.leadingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            trailing: view.safeAreaLayoutGuide.trailingAnchor,
            padding: .init(all: .zero)
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
            padding: .init(top: 0, left: 4, bottom: 0, right: 0)
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
            padding: .init(top: 0, left: 4, bottom: 0, right: 0)
        )
        popularMoviesCollectionView.anchor(
            top: popularMoviesLabelStack.bottomAnchor,
            leading: popularMoviesStack.leadingAnchor,
            trailing: popularMoviesStack.trailingAnchor,
            padding: .init(all: .zero)
        )
        
        topRatedMoviesStack.anchor(
            leading: scrollStack.leadingAnchor,
            trailing: scrollStack.trailingAnchor,
            padding: .init(all: .zero)
        )
        topRatedMoviesLabelStack.anchor(
            top: topRatedMoviesStack.topAnchor,
            leading: topRatedMoviesStack.leadingAnchor,
            trailing: topRatedMoviesStack.trailingAnchor,
            padding: .init(top: 0, left: 4, bottom: 0, right: 0)
        )
        topRatedMoviesCollectionView.anchor(
            top: topRatedMoviesLabelStack.bottomAnchor,
            leading: topRatedMoviesStack.leadingAnchor,
            trailing: topRatedMoviesStack.trailingAnchor,
            padding: .init(all: .zero)
        )
        
        upcomingMoviesStack.anchor(
            leading: scrollStack.leadingAnchor,
            trailing: scrollStack.trailingAnchor,
            padding: .init(all: .zero)
        )
        upcomingMoviesLabelStack.anchor(
            top: upcomingMoviesStack.topAnchor,
            leading: upcomingMoviesStack.leadingAnchor,
            trailing: upcomingMoviesStack.trailingAnchor,
            padding: .init(top: 0, left: 4, bottom: 0, right: 0)
        )
        upcomingMoviesCollectionView.anchor(
            top: upcomingMoviesLabelStack.bottomAnchor,
            leading: upcomingMoviesStack.leadingAnchor,
            trailing: upcomingMoviesStack.trailingAnchor,
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
                    self.upcomingMoviesCollectionView.reloadData()
                }
            case .error(message: let message):
                showMessage(title: message)
            }
        }
    }
    
    @objc func changeSegment(sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
       
        switch index {
        case 1:
            DispatchQueue.main.async {
                self.nowPlayingMovieLabel.text = "On The Air"
                self.popularMovieLabel.text = "Popular Tv Shows"
                self.topRatedMovieLabel.text = "Top Rated Tv Shows"
                self.upcomingMovieLabel.text = "Airing Today"
                
                self.viewModel?.getOnTheAirTvShows()
                self.viewModel?.getPopularTvShows()
                self.viewModel?.getAiringTodayTvShows()
                self.viewModel?.getTopRatedTvShows()
            }
        default:
            DispatchQueue.main.async {
                self.nowPlayingMovieLabel.text = "Now Playing"
                self.popularMovieLabel.text = "Popular Movies"
                self.topRatedMovieLabel.text = "Top Rated Movies"
                self.upcomingMovieLabel.text = "Upcoming Movies"
                
                self.viewModel?.getNowPlayingMovies()
                self.viewModel?.getPopularMovies()
                self.viewModel?.getTopRatedMovies()
                self.viewModel?.getUpcomingMovies()
            }
        }
    }
        
    @objc fileprivate func nowPlayingSeeAllButtonClicked() {
        if segmentView.selectedSegmentIndex == 0 {
            viewModel?.showAllItems(listType: .movie(.nowPlaying))
        } else {
            viewModel?.showAllItems(listType: .tvShow(.onTheAir))
        }
    }
    
    @objc fileprivate func popularMoviesSeeAllButtonClicked() {
        if segmentView.selectedSegmentIndex == 0 {
            viewModel?.showAllItems(listType: .movie(.popular))
        } else {
            viewModel?.showAllItems(listType: .tvShow(.onTheAir))
        }
    }
    
    @objc fileprivate func topRatedMoviesSeeAllButtonClicked() {
        if segmentView.selectedSegmentIndex == 0 {
            viewModel?.showAllItems(listType: .movie(.topRated))
        } else {
            viewModel?.showAllItems(listType: .tvShow(.topRated))
        }
    }
    
    @objc fileprivate func upcomingMoviesSeeAllButtonClicked() {
        if segmentView.selectedSegmentIndex == 0 {
            viewModel?.showAllItems(listType: .movie(.upcoming))
        } else {
            viewModel?.showAllItems(listType: .tvShow(.airingToday))
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if segmentView.selectedSegmentIndex == 0 {
            if collectionView == nowPlayingMoviesCollectionView {
                return viewModel?.getNowPlayingMovieItems() ?? 0
            }
            else if collectionView == popularMoviesCollectionView {
                return viewModel?.getPopularMovieItems() ?? 0
            }
            else if collectionView == topRatedMoviesCollectionView {
                return viewModel?.getTopRatedMovieItems() ?? 0
            }
            else if collectionView == upcomingMoviesCollectionView {
                return viewModel?.getUpcomingMovieItems() ?? 0
            }
        } else {
            if collectionView == nowPlayingMoviesCollectionView {
                return viewModel?.getOnTheAirTvShowItems() ?? 0
            }
            else if collectionView == popularMoviesCollectionView {
                return viewModel?.getPopularTvShowItems() ?? 0
            }
            else if collectionView == topRatedMoviesCollectionView {
                return viewModel?.getTopRatedTvShowItems() ?? 0
            }
            else if collectionView == upcomingMoviesCollectionView {
                return viewModel?.getAiringTodayTvShowItems() ?? 0
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleImageCollectionViewCell", for: indexPath) as? TitleImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        if segmentView.selectedSegmentIndex == 0 {
            var item: TitleImageCellProtocol?
            if collectionView == nowPlayingMoviesCollectionView {
                item = viewModel?.getNowPlayingMovieProtocol(index: indexPath.row)
                cell.configureCell(model: item)
            }
            else if collectionView == popularMoviesCollectionView {
                item = viewModel?.getPopularMovieProtocol(index: indexPath.row)
                cell.configureCell(model: item)
            }
            else if collectionView == topRatedMoviesCollectionView {
                item = viewModel?.getTopRatedMovieProtocol(index: indexPath.row)
                cell.configureCell(model: item)
            }
            else if collectionView == upcomingMoviesCollectionView {
                item = viewModel?.getUpcomingMoviesProtocol(index: indexPath.row)
                cell.configureCell(model: item)
            }
        } else {
            var item: TitleImageCellProtocol?
            if collectionView == nowPlayingMoviesCollectionView {
                item = viewModel?.getOnTheAirTvShowProtocol(index: indexPath.row)
                cell.configureCell(model: item)
            }
            else if collectionView == popularMoviesCollectionView {
                item = viewModel?.getPopularTvShowProtocol(index: indexPath.row)
                cell.configureCell(model: item)
            }
            else if collectionView == topRatedMoviesCollectionView {
                item = viewModel?.getTopRatedTvShowProtocol(index: indexPath.row)
                cell.configureCell(model: item)
            }
            else if collectionView == upcomingMoviesCollectionView {
                item = viewModel?.getAiringTodayTvShowProtocol(index: indexPath.row)
                cell.configureCell(model: item)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == nowPlayingMoviesCollectionView {
            guard let item = viewModel?.getNowPlayingMovie(index: indexPath.row) else {return}
            viewModel?.showMovieDetail(movieID: item)
        }
        else if collectionView == popularMoviesCollectionView {
            guard let item = viewModel?.getPopularMovie(index: indexPath.row) else {return}
            viewModel?.showMovieDetail(movieID: item)
        }
        else if collectionView == topRatedMoviesCollectionView {
            guard let item = viewModel?.getTopRatedMovie(index: indexPath.row) else {return}
            viewModel?.showMovieDetail(movieID: item)
        }
        else if collectionView == upcomingMoviesCollectionView {
            guard let item = viewModel?.getUpcomingMovie(index: indexPath.row) else {return}
            viewModel?.showMovieDetail(movieID: item)
        }
    }
}
