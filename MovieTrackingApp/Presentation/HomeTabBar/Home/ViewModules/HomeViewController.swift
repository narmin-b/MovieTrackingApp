//
//  HomeViewController.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 19.12.24.
//

import UIKit

enum Time: String {
    case week
    case day
}

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
    private(set) lazy var listCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cell: TitleImageCell.self)
        collectionView.register(cell: TrendingTitleCell.self)
        collectionView.register(cell: TitlesSwitchSegmentCell.self)
        collectionView.register(header: ListSectionHeader.self)
        collectionView.register(header: TrendingSegmentHeader.self)
        collectionView.backgroundColor = .clear
        collectionView.refreshControl = refreshControl
        return collectionView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadPage), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .white
        view.tintColor = .white
        view.hidesWhenStopped = true
        view.backgroundColor = .backgroundMain
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let viewModel: HomeViewModel
    private let layout: HomeCollectionLayout
    private var selectedSegmentBool: Bool = false
    private var selectedTrendingSegmentTime: Time = .week
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        self.layout = HomeCollectionLayout()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureViewModel()
        viewModel.getTrendingMovies(time: selectedTrendingSegmentTime)
        viewModel.getNowPlayingMovies()
        viewModel.getPopularMovies()
        viewModel.getTopRatedMovies()
        viewModel.getUpcomingMovies()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        configureNavigationBar()
        view.backgroundColor = .backgroundMain
        view.addSubViews(loadingView, listCollectionView)
        view.bringSubviewToFront(loadingView)

        configureCompositionalLayout()
    }
    
    fileprivate func configureNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        navigationController?.navigationBar.tintColor = .primaryHighlight
    }
    
    
    override func configureConstraint() {
        listCollectionView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: 0, right: 0)
        )
        loadingView.fillSuperviewSafeAreaLayoutGuide()
    }
    
    private func configureViewModel() {
        viewModel.requestCallback = { [weak self] state in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch state {
                case .loading:
                    self.loadingView.startAnimating()
                case .loaded:
                    self.loadingView.stopAnimating()
                    self.refreshControl.endRefreshing()
                case .success:
                    self.listCollectionView.reloadSections(.init(arrayLiteral: 1,2,3,4,5))
                case .error(let error):
                    self.showMessage(title: "Error", message: error)
                }
            }
        }
    }
    
    @objc private func reloadPage() {
        if selectedSegmentBool {
            viewModel.getTrendingTvShows(time: selectedTrendingSegmentTime)
            viewModel.getOnTheAirTvShows()
            viewModel.getPopularTvShows()
            viewModel.getAiringTodayTvShows()
            viewModel.getTopRatedTvShows()
        } else {
            viewModel.getTrendingMovies(time: selectedTrendingSegmentTime)
            viewModel.getNowPlayingMovies()
            viewModel.getPopularMovies()
            viewModel.getTopRatedMovies()
            viewModel.getUpcomingMovies()
        }
    }
    
    fileprivate func logoNavBarConfiguration() {
        let logo = UIImage(named: "logoMain")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
    
    fileprivate func configureNavigationBarTitle(labelStr: String, with offset: CGFloat) {
        let navigationView = UIView()
        navigationView.translatesAutoresizingMaskIntoConstraints = false
        let label = UILabel()
        label.text = labelStr
        label.sizeToFit()
        label.textAlignment = .center
        label.font = UIFont(name: "Nexa-Bold", size: 20)
        label.textColor = .white.withAlphaComponent(offset)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        navigationView.addSubview(label)
        label.centerXToView(to: navigationView)
        label.centerYToView(to: navigationView)

        navigationItem.titleView = navigationView
    }
}

//MARK: UICollectionViewCompositionalLayout
extension HomeViewController {
    fileprivate func configureCompositionalLayout() {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            guard let self = self else { return nil }
            
            let section: NSCollectionLayoutSection
            switch sectionIndex {
            case 0:
                section = self.layout.titlesSegmentSection()
            case 1:
                section = self.layout.trendingSection()
                
                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(50)
                )
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
                section.boundarySupplementaryItems = [header]
            default:
                section = self.layout.titlesSection()
                
                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(50)
                )
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
                section.boundarySupplementaryItems = [header]
            }
            return section
        }
        listCollectionView.setCollectionViewLayout(layout, animated: true)
    }
}

//MARK: UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate,
                          UICollectionViewDataSource,
                          UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            switch selectedSegmentBool {
            case false:
                switch section {
                case 0: return 1
                case 1: return viewModel.getTrendingMovieItems()
                case 2: return viewModel.getNowPlayingMovieItems()
                case 3: return viewModel.getTopRatedMovieItems()
                case 4: return viewModel.getPopularMovieItems()
                case 5: return viewModel.getUpcomingMovieItems()
                default: return viewModel.getNowPlayingMovieItems()
                }
            case true:
                switch section {
                case 0: return 1
                case 1 : return viewModel.getTrendingTvShowItems()
                case 2: return viewModel.getOnTheAirTvShowItems()
                case 3: return viewModel.getTopRatedTvShowItems()
                case 4: return viewModel.getPopularTvShowItems()
                case 5: return viewModel.getAiringTodayTvShowItems()
                default: return viewModel.getOnTheAirTvShowItems()
                }
            }
        }
            
    func numberOfSections(
        in collectionView: UICollectionView
    ) -> Int { 6 }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            switch selectedSegmentBool {
            case false:
                switch indexPath.section {
                case 0:
                    let cell: TitlesSwitchSegmentCell = collectionView.dequeue(for: indexPath)
                    cell.delegate = self
                    return cell
                case 1:
                    let cell: TrendingTitleCell = collectionView.dequeue(for: indexPath)
                    let item = viewModel.getTrendingMovieProtocol(index: indexPath.item)
                    cell.configureCell(model: item)
                    return cell
                case 2:
                    let cell: TitleImageCell = collectionView.dequeue(for: indexPath)
                    let item = viewModel.getNowPlayingMovieProtocol(index: indexPath.item)
                    cell.configureCell(model: item)
                    return cell
                case 3:
                    let cell: TitleImageCell = collectionView.dequeue(for: indexPath)
                    let item = viewModel.getTopRatedMovieProtocol(index: indexPath.item)
                    cell.configureCell(model: item)
                    return cell
                case 4:
                    let cell: TitleImageCell = collectionView.dequeue(for: indexPath)
                    let item = viewModel.getPopularMovieProtocol(index: indexPath.item)
                    cell.configureCell(model: item)
                    return cell
                case 5:
                    let cell: TitleImageCell = collectionView.dequeue(for: indexPath)
                    let item = viewModel.getUpcomingMoviesProtocol(index: indexPath.item)
                    cell.configureCell(model: item)
                    return cell
                default:
                    let cell: TitleImageCell = collectionView.dequeue(for: indexPath)
                    return cell
                }
            case true:
                switch indexPath.section {
                case 0:
                    let cell: TitlesSwitchSegmentCell = collectionView.dequeue(for: indexPath)
                    cell.delegate = self
                    return cell
                case 1:
                    let cell: TrendingTitleCell = collectionView.dequeue(for: indexPath)
                    let item = viewModel.getTrendingTvShowProtocol(index: indexPath.item)
                    cell.configureCell(model: item)
                    return cell
                case 2:
                    let cell: TitleImageCell = collectionView.dequeue(for: indexPath)
                    let item = viewModel.getOnTheAirTvShowProtocol(index: indexPath.item)
                    cell.configureCell(model: item)
                    return cell
                case 3:
                    let cell: TitleImageCell = collectionView.dequeue(for: indexPath)
                    let item = viewModel.getTopRatedTvShowProtocol(index: indexPath.item)
                    cell.configureCell(model: item)
                    return cell
                case 4:
                    let cell: TitleImageCell = collectionView.dequeue(for: indexPath)
                    let item = viewModel.getPopularTvShowProtocol(index: indexPath.item)
                    cell.configureCell(model: item)
                    return cell
                case 5:
                    let cell: TitleImageCell = collectionView.dequeue(for: indexPath)
                    let item = viewModel.getAiringTodayTvShowProtocol(index: indexPath.item)
                    cell.configureCell(model: item)
                    return cell
                default:
                    let cell: TitleImageCell = collectionView.dequeue(for: indexPath)
                    return cell
                }
            }
        }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath) {
            var item: Int = 0
            switch selectedSegmentBool {
            case false:
                switch indexPath.section {
                case 1:
                    item = viewModel.getTrendingMovie(index: indexPath.item)
                case 2:
                    item = viewModel.getNowPlayingMovie(index: indexPath.item)
                case 3:
                    item = viewModel.getTopRatedMovie(index: indexPath.item)
                case 4:
                    item = viewModel.getPopularMovie(index: indexPath.item)
                case 5:
                    item = viewModel.getUpcomingMovie(index: indexPath.item)
                default:
                    break
                }
                print(item)
                viewModel.showTitleDetail(mediaType: .movie, id: item)
            case true:
                switch indexPath.section {
                case 1:
                    item = viewModel.getTrendingTvShowItem(index: indexPath.item)
                case 2:
                    item = viewModel.getOnTheAirTvShowItem(index: indexPath.item)
                case 3:
                    item = viewModel.getTopRatedTvShowItem(index: indexPath.item)
                case 4:
                    item = viewModel.getPopularTvShowItem(index: indexPath.item)
                case 5:
                    item = viewModel.getAiringTodayTvShowItem(index: indexPath.item)
                default:
                    break
                }
                print(item)
                viewModel.showTitleDetail(mediaType: .tvShow, id: item)
            }
        }
        
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if indexPath.section == 1 {
            let trendingHeader: TrendingSegmentHeader = collectionView.dequeue(header: TrendingSegmentHeader.self, for: indexPath)
            
            trendingHeader.updateSegment(selectedIndex: (selectedTrendingSegmentTime == .week ? 0 : 1))
            
            trendingHeader.trendingSegmentClicked = { [weak self] segment in
                guard let self = self else { return }
                print(#function)
                self.trendingSegmentClicked(segmentIndex: segment)
            }
            return trendingHeader
        } else {
            let header: ListSectionHeader = collectionView.dequeue(header: ListSectionHeader.self, for: indexPath)
            
            switch selectedSegmentBool {
            case false:
                switch indexPath.section {
                case 2:
                    header.configure(with: "Now Playing Movies")
                case 3:
                    header.configure(with: "Top Rated Movies")
                case 4:
                    header.configure(with: "Popular Movies")
                case 5:
                    header.configure(with: "Upcoming Movies")
                default:
                    break
                }
            case true:
                switch indexPath.section {
                case 2:
                    header.configure(with: "On The Air")
                case 3:
                    header.configure(with: "Top Rated Tv Shows")
                case 4:
                    header.configure(with: "Popular Tv Shows")
                case 5:
                    header.configure(with: "Airing Today")
                default:
                    break
                }
            }
            
            header.seeAllButtonAction = { [weak self] in
                guard let self = self else { return }
                seeAllButtonClicked(section: indexPath.section)
            }
            return header
        }
    }
    
    fileprivate func trendingSegmentClicked(segmentIndex: Int){
        selectedTrendingSegmentTime = (segmentIndex == 0) ? .week : .day
        switch selectedSegmentBool {
        case false:
                viewModel.getTrendingMovies(time: selectedTrendingSegmentTime)
        case true:
                viewModel.getTrendingTvShows(time: selectedTrendingSegmentTime)
        }
    }
    
    fileprivate func seeAllButtonClicked(section: Int){
        switch selectedSegmentBool {
        case false:
            switch section {
            case 2:
                viewModel.showAllItems(listType: .movie(.nowPlaying))
            case 3:
                viewModel.showAllItems(listType: .movie(.topRated))
            case 4:
                viewModel.showAllItems(listType: .movie(.popular))
            case 5:
                viewModel.showAllItems(listType: .movie(.upcoming))
            default:
                break
            }
        case true:
            switch section {
            case 2:
                viewModel.showAllItems(listType: .tvShow(.onTheAir))
            case 3:
                viewModel.showAllItems(listType: .tvShow(.topRated))
            case 4:
                viewModel.showAllItems(listType: .tvShow(.popular))
            case 5:
                viewModel.showAllItems(listType: .tvShow(.airingToday))
            default:
                break
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var labelStr: String
        if selectedSegmentBool {
            labelStr = "Tv Shows"
        } else {
            labelStr = "Movies"
        }
        var offset = scrollView.contentOffset.y / 150

        if offset > 1 {
            offset = 1
            configureNavigationBarTitle(labelStr: labelStr, with: offset)
        } else {
            if offset <= 0 {
                logoNavBarConfiguration()
            } else {
                configureNavigationBarTitle(labelStr: labelStr, with: offset)
            }
        }
    }
}

extension HomeViewController: TitlesSwitchSegmentCellDelegate {
    func didClickSegment(index: Int) {
        selectedSegmentBool.toggle()
        
        if selectedSegmentBool {
            viewModel.getTrendingTvShows(time: selectedTrendingSegmentTime)
            viewModel.getOnTheAirTvShows()
            viewModel.getPopularTvShows()
            viewModel.getAiringTodayTvShows()
            viewModel.getTopRatedTvShows()
        } else {
            viewModel.getTrendingMovies(time: selectedTrendingSegmentTime)
            viewModel.getNowPlayingMovies()
            viewModel.getPopularMovies()
            viewModel.getTopRatedMovies()
            viewModel.getUpcomingMovies()
        }
    }
}
