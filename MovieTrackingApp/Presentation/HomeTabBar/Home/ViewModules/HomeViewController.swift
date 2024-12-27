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
    private(set) lazy var listCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cell: TitleImageCell.self)
        collectionView.register(cell: TitlesSwitchSegmentCell.self)
        collectionView.register(header: ListSectionHeader.self)
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
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        
        viewModel.getNowPlayingMovies()
        viewModel.getPopularMovies()
        viewModel.getTopRatedMovies()
        viewModel.getUpcomingMovies()
    }
    
    override func configureView() {
        view.backgroundColor = .backgroundMain
        view.addSubViews(loadingView, listCollectionView)
        view.bringSubviewToFront(loadingView)

        configureCompositionalLayout()
    }
    
    override func configureConstraint() {
        listCollectionView.fillSuperviewSafeAreaLayoutGuide()
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
                        self.listCollectionView.reloadSections(.init(arrayLiteral: 1,2,3,4))
                    case .error(let error):
                        self.showMessage(title: "Error", message: error)
                }
            }
        }
    }
    
    @objc private func reloadPage() {
        if selectedSegmentBool {
            viewModel.getOnTheAirTvShows()
            viewModel.getPopularTvShows()
            viewModel.getAiringTodayTvShows()
            viewModel.getTopRatedTvShows()
        } else {
            viewModel.getNowPlayingMovies()
            viewModel.getPopularMovies()
            viewModel.getTopRatedMovies()
            viewModel.getUpcomingMovies()
        }
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
                case 1 : return viewModel.getNowPlayingMovieItems()
                case 2: return viewModel.getTopRatedMovieItems()
                case 3: return viewModel.getPopularMovieItems()
                case 4: return viewModel.getUpcomingMovieItems()
                default: return viewModel.getNowPlayingMovieItems()
                }
            case true:
                switch section {
                case 0: return 1
                case 1 : return viewModel.getOnTheAirTvShowItems()
                case 2: return viewModel.getTopRatedTvShowItems()
                case 3: return viewModel.getPopularTvShowItems()
                case 4: return viewModel.getAiringTodayTvShowItems()
                default: return viewModel.getNowPlayingMovieItems()
                }
            }
        }
            
    func numberOfSections(
        in collectionView: UICollectionView
    ) -> Int { 5 }
    
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
                    let cell: TitleImageCell = collectionView.dequeue(for: indexPath)
                    let item = viewModel.getNowPlayingMovieProtocol(index: indexPath.item)
                    cell.configureCell(model: item)
                    return cell
                case 2:
                    let cell: TitleImageCell = collectionView.dequeue(for: indexPath)
                    let item = viewModel.getTopRatedMovieProtocol(index: indexPath.item)
                    cell.configureCell(model: item)
                    return cell
                case 3:
                    let cell: TitleImageCell = collectionView.dequeue(for: indexPath)
                    let item = viewModel.getPopularMovieProtocol(index: indexPath.item)
                    cell.configureCell(model: item)
                    return cell
                case 4:
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
                    let cell: TitleImageCell = collectionView.dequeue(for: indexPath)
                    let item = viewModel.getOnTheAirTvShowProtocol(index: indexPath.item)
                    cell.configureCell(model: item)
                    return cell
                case 2:
                    let cell: TitleImageCell = collectionView.dequeue(for: indexPath)
                    let item = viewModel.getTopRatedTvShowProtocol(index: indexPath.item)
                    cell.configureCell(model: item)
                    return cell
                case 3:
                    let cell: TitleImageCell = collectionView.dequeue(for: indexPath)
                    let item = viewModel.getPopularTvShowProtocol(index: indexPath.item)
                    cell.configureCell(model: item)
                    return cell
                case 4:
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
            switch indexPath.section {
            case 1:
                let item = viewModel.getNowPlayingMovie(index: indexPath.item)
                viewModel.showMovieDetail(movieID: item)
            case 2:
                let item = viewModel.getNowPlayingMovie(index: indexPath.item)
                viewModel.showMovieDetail(movieID: item)
            case 3:
                let item = viewModel.getNowPlayingMovie(index: indexPath.item)
                viewModel.showMovieDetail(movieID: item)
            case 4:
                let item = viewModel.getNowPlayingMovie(index: indexPath.item)
                viewModel.showMovieDetail(movieID: item)
            default:
                break
            }
        }
        
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let header: ListSectionHeader = collectionView.dequeue(header: ListSectionHeader.self, for: indexPath)
        
        switch selectedSegmentBool {
        case false:
            switch indexPath.section {
            case 1:
                header.configure(with: "Now Playing Movies")
            case 2:
                header.configure(with: "Top Rated Movies")
            case 3:
                header.configure(with: "Popular Movies")
            case 4:
                header.configure(with: "Upcoming Movies")
            default:
                break
            }
        case true:
            switch indexPath.section {
            case 1:
                header.configure(with: "On The Air")
            case 2:
                header.configure(with: "Top Rated Tv Shows")
            case 3:
                header.configure(with: "Popular Tv Shows")
            case 4:
                header.configure(with: "Airing Today")
            default:
                break
            }
        }
        header.seeAllButtonAction = {
            self.seeAllButtonClicked(section: indexPath.section)
        }
        return header
    }
    
    fileprivate func seeAllButtonClicked(section: Int){
        switch selectedSegmentBool {
        case false:
            switch section {
            case 1:
                viewModel.showAllItems(listType: .movie(.nowPlaying))
            case 2:
                viewModel.showAllItems(listType: .movie(.topRated))
            case 3:
                viewModel.showAllItems(listType: .movie(.popular))
            case 4:
                viewModel.showAllItems(listType: .movie(.upcoming))
            default:
                break
            }
        case true:
            switch section {
            case 1:
                viewModel.showAllItems(listType: .tvShow(.onTheAir))
            case 2:
                viewModel.showAllItems(listType: .tvShow(.topRated))
            case 3:
                viewModel.showAllItems(listType: .tvShow(.popular))
            case 4:
                viewModel.showAllItems(listType: .tvShow(.airingToday))
            default:
                break
            }
        }
    }
}

extension HomeViewController: TitlesSwitchSegmentCellDelegate {
    func didClickSegment(index: Int) {
        selectedSegmentBool.toggle()
        
        if selectedSegmentBool {
            viewModel.getOnTheAirTvShows()
            viewModel.getPopularTvShows()
            viewModel.getAiringTodayTvShows()
            viewModel.getTopRatedTvShows()
        } else {
            viewModel.getNowPlayingMovies()
            viewModel.getPopularMovies()
            viewModel.getTopRatedMovies()
            viewModel.getUpcomingMovies()
        }
        listCollectionView.reloadSections(.init(arrayLiteral: 1,2,3,4))
    }
}
