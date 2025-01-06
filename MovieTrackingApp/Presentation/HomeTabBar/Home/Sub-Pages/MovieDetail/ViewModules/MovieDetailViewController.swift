//
//  MovieDetailController.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 19.12.24.
//

import UIKit
enum InfoList: String, CaseIterable {
    case genre, originCountry
}


final class MovieDetailController: BaseViewController {
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .black
        view.tintColor = .black
        view.hidesWhenStopped = true
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backdropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "testing")
        imageView.backgroundColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.anchorSize(.init(width: 120, height: 180))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = ReusableLabel(labelText: "Title Test")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
//    private let genreLabel: UILabel = {
//        let label = ReusableLabel(labelText: "Genre Test")
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
    
    private lazy var languageLabel: UILabel = {
        let label = ReusableLabel(labelText: "Language Test")
//        label.attributedText = configureLabel(icon: "star", text: "Rating")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var runtimeLabel: UILabel = {
        let label = ReusableLabel(labelText: "Overview Test")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var releaseDateLabel: UILabel = {
        let label = ReusableLabel(labelText: "Release Date Test")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var initInfoStackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [languageLabel, runtimeLabel, releaseDateLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var voteCountLabel: UILabel = {
        let label = ReusableLabel(labelText: "Vote Count Test")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var voteAverageLabel: UILabel = {
        let label = ReusableLabel(labelText: "Vote Average Test")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var overviewLabel: UILabel = {
        let label = ReusableLabel(labelText: "Overview Test")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.addSubview(scrollStack)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var scrollStack: UIStackView = {
        let scrollStack = UIStackView(arrangedSubviews: [backdropImageView, posterImageView, initInfoStackView, infoCollectionView])
        scrollStack.axis = .vertical
        scrollStack.spacing = 16
        scrollStack.backgroundColor = .red
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
                    print("success called")
                    self.configureDetails()
                case .error(message: let message):
                    self.showMessage(title: message)
                }
            }
        }
    }
    
    override func configureView() {
        view.backgroundColor = .backgroundMain
        view.addSubViews(scrollView) /*, posterImageView, initInfoStackView, infoCollectionView*/
//        titleLabel.text = viewModel?.getMovieName()
//        configureDetails()
    }
    
    override func configureConstraint() {
        loadingView.fillSuperview()
        
        scrollView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(all: .zero)
        )
        
        scrollStack.anchorSize(to: scrollView)
        scrollStack.anchor(
            top: scrollView.topAnchor,
            leading: scrollView.leadingAnchor,
            bottom: scrollView.bottomAnchor,
            trailing: scrollView.trailingAnchor,
            padding: .init(all: .zero)
        )
        
//        backdropImageView.fillSuperview()
        
        backdropImageView.anchor(
            top: scrollStack.topAnchor,
            leading: scrollStack.leadingAnchor,
            trailing: scrollStack.trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: 0, right: 0)
        )
        backdropImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        posterImageView.anchor(
            top: backdropImageView.topAnchor,
            padding: .init(top: 50, left: 0, bottom: 0, right: 0)
        )
        posterImageView.centerXToSuperview()
        
        initInfoStackView.anchor(
            top: posterImageView.bottomAnchor,
            leading: scrollStack.leadingAnchor,
            trailing: scrollStack.trailingAnchor,
            padding: .init(top: 10, left: 0, bottom: 0, right: 0)
        )
        
        infoCollectionView.anchor(
            top: initInfoStackView.bottomAnchor,
            leading: scrollStack.leadingAnchor,
            trailing: scrollStack.trailingAnchor,
            padding: .init(top: 10, left: 0, bottom: 0, right: 0)
        )
////        titleLabel.centerXToSuperview()
////        titleLabel.centerYToSuperview()
    }
        
    override func configureTargets() {
        
    }
    
    fileprivate func configureDetails() {
        let imageURL = viewModel?.getBackdropImage() ?? ""
        backdropImageView.loadImageURL(url: imageURL)
    }
    
    fileprivate func configureLabel(icon: String, text: String) -> NSAttributedString {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: icon)
        imageAttachment.bounds = CGRect(x: 0, y: 0, width: 12, height: 12)
        
        let attributedText = NSMutableAttributedString(string: "")
        attributedText.append(NSAttributedString(attachment: imageAttachment))
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

