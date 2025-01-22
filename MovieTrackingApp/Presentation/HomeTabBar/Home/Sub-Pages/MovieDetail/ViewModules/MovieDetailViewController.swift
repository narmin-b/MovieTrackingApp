//
//  MovieDetailController.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 19.12.24.
//

import UIKit
import WebKit

//enum RatingStar: IntegerLiteralType {
//    case 1 = "1"
//    case 2 = "2"
//    case 3 = "3"
//    case 4 = "4"
//    case 5 = "5"
//}

enum MovieInfoList: String, CaseIterable {
    case genre = "Genres"
    case originCountry = "Origin Country"
    case vote = "Vote Average"
}

enum TvShowInfoList: String, CaseIterable {
    case genre = "Genres"
    case originCountry = "Origin Country"
    case vote = "Vote Average"
    case numOfEpisodes = "Number Of Episodes"
}

final class MovieDetailController: BaseViewController {
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .white
        view.tintColor = .white
        view.hidesWhenStopped = true
        view.backgroundColor = .backgroundMain
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var rate1Button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.tintColor = .primaryHighlight
        button.tag = 1
        return button
    }()
    
    private lazy var rate2Button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.tintColor = .primaryHighlight
        button.tag = 2
        return button
    }()
    
    private lazy var rate3Button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.tintColor = .primaryHighlight
        button.tag = 3
        return button
    }()
    
    private lazy var rate4Button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.tintColor = .primaryHighlight
        button.tag = 4
        return button
    }()
    
    private lazy var rate5Button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.tintColor = .primaryHighlight
        button.tag = 5
        return button
    }()
    
    private lazy var ratingStackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [rate1Button, rate2Button, rate3Button, rate4Button, rate5Button])
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.backgroundColor = .clear
//        stackView.anchorSize(.init(width: 50, height: 0))
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var trailerLabel: UILabel = {
        let label = ReusableLabel(labelText: "Trailer", labelColor: .white, labelFont: "Nexa-Bold", labelSize: 38, numOfLines: 1)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.backgroundColor = .clear
        return webView
    }()
    
    private lazy var backdropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "baseBackdrop")
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var posterImageContainerView: UIView = {
        let view = UIView()
        view.addSubViews(posterImageView, titleLabel)
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.layer.borderWidth = 0.3
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.image = UIImage(named: "basePoster")
        imageView.anchorSize(.init(width: 120, height: 180))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = ReusableLabel(labelText: "Test", labelColor: .white, labelFont: "Nexa-Bold", labelSize: 28, numOfLines: 2)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var languageLabel: UILabel = {
        let label = ReusableLabel(labelText: "Language Test", labelColor: .lightGray, labelFont: "Nexa-Bold", labelSize: 16, numOfLines: 1)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var runtimeLabel: UILabel = {
        let label = ReusableLabel(labelText: "Overview Test", labelColor: .lightGray, labelFont: "Nexa-Bold", labelSize: 16, numOfLines: 1)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var releaseDateLabel: UILabel = {
        let label = ReusableLabel(labelText: "Release Date Test", labelColor: .lightGray, labelFont: "Nexa-Bold", labelSize: 16, numOfLines: 1)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var initInfoStackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [languageLabel, runtimeLabel, releaseDateLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 4
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var infoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(cell: MovieDetailCollectionViewCell.self)
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var overviewContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .accentMain.withAlphaComponent(0.7)
        view.addSubview(overviewLabel)
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var overviewLabel: UILabel = {
        let label = ReusableLabel(labelText: "Overview Test", labelColor: .white, labelFont: "NexaRegular", labelSize: 16, numOfLines: 0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.addSubview(scrollStack)
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var scrollStack: UIStackView = {
        let scrollStack = UIStackView(arrangedSubviews: [backdropImageView, posterImageContainerView, ratingStackView, initInfoStackView, overviewContainerView, infoCollectionView, trailerLabel, webView])
        scrollStack.axis = .vertical
        scrollStack.spacing = 16
        scrollStack.backgroundColor = .clear
        scrollStack.translatesAutoresizingMaskIntoConstraints = false
        return scrollStack
    }()
    
    private let viewModel: MovieDetailViewModel?
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
//        viewModel?.getRatedList()
        viewModel?.getDetails()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = infoCollectionView.contentSize.height
        infoCollectionView.anchorSize(.init(width: 0, height: height))
        infoCollectionView.layoutIfNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
    }
    
    fileprivate func configureNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    init(viewModel: MovieDetailViewModel?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        viewModel?.requestCallback = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
                    self.infoCollectionView.reloadData()
                    self.configureDetails()
                    self.getRating()
                case .ratingSuccess:
                    self.infoCollectionView.reloadData()
                    self.configureDetails()
                case .error(message: let message):
                    self.loadingView.stopAnimating()
                    self.showMessage(title: message)
                    self.viewModel?.popControllerBack()
                }
            }
        }
    }
    
    override func configureView() {
        view.backgroundColor = .backgroundMain
        view.addSubViews(loadingView, scrollView)
        view.bringSubviewToFront(loadingView)
    }
    
    override func configureConstraint() {
        loadingView.fillSuperview()
        
        scrollView.anchor(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: -16, right: 0)
        )
        
        scrollStack.anchor(
            top: scrollView.topAnchor,
            leading: scrollView.leadingAnchor,
            bottom: scrollView.bottomAnchor,
            trailing: scrollView.trailingAnchor,
            padding: .init(all: 0)
        )
        scrollStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        backdropImageView.anchor(
            top: scrollStack.topAnchor,
            leading: scrollStack.leadingAnchor,
            trailing: scrollStack.trailingAnchor,
            padding: .init(all: .zero)
        )
        
        posterImageContainerView.anchor(
            top: backdropImageView.topAnchor,
            leading: scrollStack.leadingAnchor,
            bottom: titleLabel.bottomAnchor,
            trailing: scrollStack.trailingAnchor,
            padding: .init(top: 50, left: 0, bottom: 0, right: 0)
        )
        
        posterImageView.anchor(
            top: posterImageContainerView.topAnchor,
            padding: .init(all: 0)
        )
        posterImageView.centerXToSuperview()
    
        titleLabel.anchor(
            top: posterImageView.bottomAnchor,
            leading: posterImageContainerView.leadingAnchor,
            trailing: posterImageContainerView.trailingAnchor,
            padding: .init(all: 8)
        )
        titleLabel.centerXToSuperview()
        
        ratingStackView.centerXToSuperview()
        ratingStackView.anchor(
            top: posterImageContainerView.bottomAnchor,
            leading: scrollStack.leadingAnchor,
            trailing: scrollStack.trailingAnchor,
            padding: .init(top: 10, left: 100, bottom: 0, right: -100)
        )
        
        initInfoStackView.anchor(
            top: ratingStackView.bottomAnchor,
            leading: scrollStack.leadingAnchor,
            trailing: scrollStack.trailingAnchor,
            padding: .init(top: 10, left: 24, bottom: 0, right: 24)
        )
        initInfoStackView.centerXToView(to: scrollView)
        
        overviewContainerView.anchor(
            leading: scrollStack.leadingAnchor,
            trailing: scrollStack.trailingAnchor,
            padding: .init(all: 12)
        )
        overviewLabel.anchor(
            top: overviewContainerView.topAnchor,
            leading: overviewContainerView.leadingAnchor,
            bottom: overviewContainerView.bottomAnchor,
            trailing: overviewContainerView.trailingAnchor,
            padding: .init(all: 8)
        )
        
        infoCollectionView.anchor(
            leading: scrollStack.leadingAnchor,
            trailing: scrollStack.trailingAnchor,
            padding: .init(top: 0, left: 12, bottom: 0, right: -12)
        )
        
        trailerLabel.anchor(
            top: infoCollectionView.bottomAnchor,
            padding: .init(all: 0)
        )
        trailerLabel.centerXToSuperview()
        
        webView.anchor(
            top: trailerLabel.bottomAnchor,
            leading: scrollStack.leadingAnchor,
            trailing: scrollStack.trailingAnchor,
            padding: .init(top: 4, left: 12, bottom: 0, right: -12)
        )
        webView.heightAnchor.constraint(equalTo: webView.widthAnchor, multiplier: 9/16).isActive = true
    }
        
    override func configureTargets() {
        rate1Button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        rate2Button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        rate3Button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        rate4Button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        rate5Button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc fileprivate func buttonTapped(_ sender: UIButton) {
        ratingButtonUIConfig(senderTag: sender.tag)
        viewModel?.setRating(rating: sender.tag*2)
    }
    
    fileprivate func ratingButtonUIConfig(senderTag: Int) {
        let buttons: [UIButton] = [rate1Button, rate2Button, rate3Button, rate4Button, rate5Button]
        
        for i in 1...senderTag {
            buttons[i-1].setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        if senderTag == 5 { return }
        for i in senderTag...4 {
            buttons[i].setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
    fileprivate func configureDetails() {
        titleLabel.text = viewModel?.getMovieTitle()
        guard let imageURL = viewModel?.getMovieBackdropImage() else { return }
        if imageURL.isEmpty { backdropImageView.image = UIImage(named: "baseBackdrop")}
        else { backdropImageView.loadImageURL(url: imageURL) }
        backdropImageView.alpha = 0.5
        
        guard let posterURL = viewModel?.getMoviePosterImage() else { return }
        if posterURL.isEmpty { posterImageView.image = UIImage(named: "basePoster")}
        else { posterImageView.loadImageURL(url: posterURL) }
        
        runtimeLabel.configureLabel(icon: "clock", text: viewModel?.getMovieRuntime() ?? "mins")
        
        languageLabel.configureLabel(icon: "globe", text: viewModel?.getMovieLanguage() ?? "Language")
        releaseDateLabel.configureLabel(icon: "calendar", text: viewModel?.getMovieReleaseDate() ?? "Date")
        
        overviewLabel.text = viewModel?.getMovieOverview()
        
        guard let videoURL = URL(string: viewModel?.getTitleTrailer() ?? "") else { return }
        webView.load(URLRequest(url: videoURL))
    }
    
    fileprivate func getRating() {
        viewModel?.loadDataAndCheckIfRated { isRated in
            print("Is Rated: \(isRated)")
            if isRated {
                guard let rate = self.viewModel?.getRating() else { return }
                self.ratingButtonUIConfig(senderTag: rate)
            } else {
                return
            }
        }
    }
}

extension MovieDetailController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let mediaType = viewModel?.getMediaType() ?? .movie
        switch mediaType {
        case .movie:
            return MovieInfoList.allCases.count * 2
        case .tvShow:
            return TvShowInfoList.allCases.count * 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieDetailCollectionViewCell", for: indexPath) as? MovieDetailCollectionViewCell else {
            return UICollectionViewCell()
        }
        let mediaType = viewModel?.getMediaType() ?? .movie

        switch mediaType {
        case .movie:
            let field = MovieInfoList.allCases[indexPath.item / 2]
            
            if(indexPath.item % 2 == 0) {
                cell.configureFieldCell(title: field)
            }
            else {
                let title = viewModel?.getTitleForMovieCell(field: field) ?? ""
                cell.configureCell(title: title)
            }
        case .tvShow:
            let field = TvShowInfoList.allCases[indexPath.item / 2]
            if(indexPath.item % 2 == 0) {
                cell.configureFieldCell(title: field)
            }
            else {
                let title = viewModel?.getTitleForTvShowCell(field: field) ?? ""
                cell.configureCell(title: title)
            }
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (infoCollectionView.frame.width)/2, height: 48)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 80, right: 0)
    }
}
