//
//  SearchViewController.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 21.12.24.
//

import UIKit

class SearchViewController: BaseViewController {
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .white
        view.tintColor = .white
        view.hidesWhenStopped = true
        view.backgroundColor = .backgroundMain
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var searchTextfield: UITextField = {
        let textfield = ReusableTextField(placeholder: "Search",
                                          iconName: "magnifyingglass",
                                          placeholderFont: "NexaRegular",
                                          placeholderColor: .lightGray,
                                          iconTintColor: .secondaryHighlight,
                                          cornerRadius: 8,
                                          backgroundColor: .accentMain,
                                          borderColor: .lightGray)
        textfield.inputAccessoryView = doneToolBar
        textfield.textColor = .white
        textfield.delegate = self
        textfield.clearButtonMode = .whileEditing
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private lazy var doneToolBar: UIToolbar = {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        keyboardToolbar.translatesAutoresizingMaskIntoConstraints = true
        return keyboardToolbar
    }()
    
    private lazy var movieSearchButton: UIButton = {
        let button = ReusableButton(title: "Movies",
                                    onAction: movieSearchEnabled,
                                    cornerRad: 12,
                                    bgColor: .primaryHighlight,
                                    titleColor: .black,
                                    titleSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var tvShowSearchButton: UIButton = {
        let button = ReusableButton(title: "Tv Shows",
                                    onAction: tvShowSearchEnabled,
                                    cornerRad: 12,
                                    bgColor: .accentMain,
                                    titleColor: .white,
                                    titleSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var searchResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 4
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 4, right: 8)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "SearchCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [movieSearchButton, tvShowSearchButton])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    
    @objc fileprivate func movieSearchEnabled() {
        searchTextfield.text = ""
        dismissKeyboard()
        
        chosenButton = movieSearchButton
        chosenButton?.buttonChosen()
        tvShowSearchButton.buttonUnchosen()
        guard let text = searchTextfield.text else { return }
        viewModel?.getList(mediaType: .movie, query: text)
    }
    
    @objc fileprivate func tvShowSearchEnabled() {
        searchTextfield.text = ""
        dismissKeyboard()
        
        chosenButton = tvShowSearchButton
        chosenButton?.buttonChosen()
        movieSearchButton.buttonUnchosen()
        guard let text = searchTextfield.text else { return }
        viewModel?.getList(mediaType: .tvShow, query: text)
    }
    
    private let viewModel: SearchViewModel?
    private var chosenButton: UIButton?
    private var isPageLoaded: Bool = true
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        chosenButton = movieSearchButton
        searchResultsCollectionView.isHidden = true
    }
    
    init(viewModel: SearchViewModel?) {
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
        view.backgroundColor = .backgroundMain
        
        view.addSubViews(loadingView, searchTextfield, buttonStackView, searchResultsCollectionView)
        view.bringSubviewToFront(loadingView)
        configureNavigationBar()
    }
    
    fileprivate func configureNavigationBar() {
        navigationItem.configureNavigationBar(text: "Search")
        navigationController?.navigationBar.tintColor = .primaryHighlight
    }
    
    override func configureConstraint() {
        loadingView.anchor(
            top: buttonStackView.bottomAnchor,
            leading: view.leadingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 4, left: 8, bottom: 0, right: -8)
        )
        
        searchTextfield.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 4, left: 8, bottom: 0, right: -8)
        )
        searchTextfield.anchorSize(.init(width: 0, height: 48))
        
        buttonStackView.anchor(
            top: searchTextfield.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 8, left: 8, bottom: 0, right: -8)
        )
        movieSearchButton.anchorSize(.init(width: 0, height: 24))
        tvShowSearchButton.anchorSize(.init(width: 0, height: 24))
        
        searchResultsCollectionView.anchor(
            top: buttonStackView.bottomAnchor,
            leading: view.leadingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 8, left: 8, bottom: 0, right: -8)
        )
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
                case .morePageLoading:
                    self.isPageLoaded = false
                case .morePageLoaded:
                    self.isPageLoaded = true
                case .success:
                    self.searchResultsCollectionView.reloadData()
                case .error(message: let message):
                    self.showMessage(title: message)
                }
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension SearchViewController: UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if chosenButton == movieSearchButton {
            viewModel?.getMovieSearchItems() ?? 0
        } else {
            viewModel?.getTvShowSearchItems() ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as? SearchCollectionViewCell else {
            return UICollectionViewCell()
        }
        if chosenButton == movieSearchButton {
            let item = viewModel?.getMovieSearchItemsProtocol(index: indexPath.row)
            cell.configureCell(model: item)
        } else {
            let item = viewModel?.getTvShowSearchItemsProtocol(index: indexPath.row)
            cell.configureCell(model: item)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 8, height: (collectionView.bounds.height - 20)/4)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath) {
            let mediaType: MediaType = chosenButton == movieSearchButton ? .movie : .tvShow
            switch mediaType {
            case .movie:
                guard let item = viewModel?.getItem(index: indexPath.item, mediaType: mediaType) else { return }
                viewModel?.showMovieDetail(mediaType: .movie, id: item)
            case .tvShow:
                guard let item = viewModel?.getItem(index: indexPath.item, mediaType: mediaType) else { return }
                viewModel?.showMovieDetail(mediaType: .tvShow, id: item)
            }
        }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let searchText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        if !searchText.isEmpty { searchResultsCollectionView.isHidden = false }
        if chosenButton == movieSearchButton {
            viewModel?.getList(mediaType: .movie, query: searchText)
        } else {
            viewModel?.getList(mediaType: .tvShow, query: searchText) 
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        
        if position > (searchResultsCollectionView.contentSize.height - 150 - scrollView.frame.size.height) && isPageLoaded == true {
            guard let searchText = searchTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines), !searchText.isEmpty else { return }
            if chosenButton == movieSearchButton {
                viewModel?.loadMorePage(mediaType: .movie, query: searchText)
            } else {
                viewModel?.loadMorePage(mediaType: .tvShow, query: searchText)
            }
        }
    }
}
