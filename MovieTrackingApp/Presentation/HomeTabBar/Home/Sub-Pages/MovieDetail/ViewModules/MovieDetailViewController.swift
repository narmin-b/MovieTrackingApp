//
//  MovieDetailController.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 19.12.24.
//

import UIKit
enum InfoList: String, CaseIterable {
    case genre = "Genres"
    case originCountry = "Origin Country"
    case vote = "Vote Average"
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
        layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieDetailCollectionViewCell.self, forCellWithReuseIdentifier: "MovieDetailCollectionViewCell")
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
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var scrollStack: UIStackView = {
        let scrollStack = UIStackView(arrangedSubviews: [backdropImageView, posterImageContainerView, initInfoStackView, infoCollectionView, overviewContainerView])
        scrollStack.axis = .vertical
        scrollStack.spacing = 16
        scrollStack.backgroundColor = .clear
        scrollStack.translatesAutoresizingMaskIntoConstraints = false
        return scrollStack
    }()
    
    private let viewModel: MovieDetailViewModel?
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.getMovieDetails()
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
                case .error(message: let message):
                    self.showMessage(title: message)
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
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: -16, right: 0)
        )
        
        scrollStack.anchorSize(to: scrollView)
        scrollStack.anchor(
            top: scrollView.topAnchor,
            leading: scrollView.leadingAnchor,
            bottom: scrollView.bottomAnchor,
            trailing: scrollView.trailingAnchor,
            padding: .init(all: .zero)
        )
        
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
        
        initInfoStackView.anchor(
            top: posterImageContainerView.bottomAnchor,
            leading: scrollStack.leadingAnchor,
            trailing: scrollStack.trailingAnchor,
            padding: .init(top: 10, left: 24, bottom: 0, right: 24)
        )
        initInfoStackView.centerXToView(to: scrollView)
        
        infoCollectionView.anchor(
            top: initInfoStackView.bottomAnchor,
            leading: scrollStack.leadingAnchor,
            trailing: scrollStack.trailingAnchor,
            padding: .init(top: 10, left: 0, bottom: 0, right: 0)
        )
        
        overviewContainerView.anchor(
            top: infoCollectionView.bottomAnchor,
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
    }
        
    override func configureTargets() {
        
    }
    
    fileprivate func configureDetails() {
        guard let imageURL = viewModel?.getBackdropImage() else { return }
        if imageURL.isEmpty { backdropImageView.image = UIImage(named: "baseBackdrop")}
        else { backdropImageView.loadImageURL(url: imageURL) }
        backdropImageView.alpha = 0.5
        
        guard let posterURL = viewModel?.getPosterImage() else { return }
        if posterURL.isEmpty { posterImageView.image = UIImage(named: "basePoster")}
        else { posterImageView.loadImageURL(url: posterURL) }
        
        titleLabel.text = viewModel?.getMovieTitle()
        
        runtimeLabel.attributedText = configureLabel(icon: "clock", text: String(viewModel?.getRuntime() ?? 0) + " min")
        
        languageLabel.attributedText = configureLabel(icon: "globe", text: viewModel?.getLanguage() ?? "Language")
        releaseDateLabel.attributedText = configureLabel(icon: "calendar", text: viewModel?.getReleaseDate() ?? "Date")
        
        overviewLabel.text = viewModel?.getOverview()
    }
    
    fileprivate func configureLabel(icon: String, text: String) -> NSAttributedString {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: icon)?.withTintColor(.primaryHighlight)
        imageAttachment.bounds = CGRect(x: 0, y: 0, width: 12, height: 12)
        
        let attributedText = NSMutableAttributedString(string: "")
        attributedText.append(NSAttributedString(attachment: imageAttachment))
        attributedText.append(NSAttributedString(string: " "))
        attributedText.append(NSAttributedString(string: text))
        
        return attributedText
    }
}

extension MovieDetailController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return InfoList.allCases.count * 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieDetailCollectionViewCell", for: indexPath) as? MovieDetailCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let field = InfoList.allCases[indexPath.item / 2]
        
        if(indexPath.item % 2 == 0) {
            cell.configureFieldCell(title: field)
        }
        else {
            let title = viewModel?.getTitleForCell(field: field) ?? ""
            cell.configureCell(title: title)
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

