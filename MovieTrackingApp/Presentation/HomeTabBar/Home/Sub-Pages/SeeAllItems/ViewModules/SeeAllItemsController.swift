//
//  SeeAllItemsController.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 19.12.24.
//

import UIKit

final class SeeAllItemsController: BaseViewController {
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .black
        view.tintColor = .black
        view.hidesWhenStopped = true
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var allMoviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        layout.sectionInset = UIEdgeInsets(top: 0, left: 4, bottom: 4, right: 4)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let viewModel: SeeAllItemsViewModel?
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    fileprivate func configureNavigationBar() {
        let navgationView = UIView()
        navgationView.translatesAutoresizingMaskIntoConstraints = false
        let label = UILabel()
        label.text = "All Movies"
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
    
    init(viewModel: SeeAllItemsViewModel?) {
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
                print(#function)
                DispatchQueue.main.async {
                    self.allMoviesCollectionView.reloadData()
                }
            case .error(message: let message):
                showMessage(title: message)
            }
        }
    }
    
    override func configureView() {
        configureNavigationBar()
        
        view.backgroundColor = .backgroundMain
        view.addSubViews(loadingView, allMoviesCollectionView)
        view.bringSubviewToFront(loadingView)
    }
    
    override func configureConstraint() {
        loadingView.centerXToSuperview()
        loadingView.centerYToSuperview()
        
        allMoviesCollectionView.fillSuperviewSafeAreaLayoutGuide()
    }
        
    
    override func configureTargets() {
        
    }
}

extension SeeAllItemsController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.getAllItems() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        let item = viewModel?.getAllItemsProtocol(index: indexPath.row) 
        cell.configureCell(model: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width-24)/4, height: (collectionView.bounds.width-24)/8*3)
    }
}
