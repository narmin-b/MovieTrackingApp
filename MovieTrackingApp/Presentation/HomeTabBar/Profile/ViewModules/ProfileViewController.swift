//
//  ProfileViewController.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 21.12.24.
//

import UIKit

enum infoList: String, CaseIterable {
    case username
    case email
}

class ProfileViewController: BaseViewController {
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .white
        view.tintColor = .white
        view.hidesWhenStopped = true
        view.backgroundColor = .backgroundMain
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var profileIcon: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "testing")
        imageview.contentMode = .scaleToFill
        imageview.layer.cornerRadius = 60
        imageview.layer.masksToBounds = true
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    private lazy var infoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 4
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ProfileInfoCollectionViewCell.self, forCellWithReuseIdentifier: "ProfileInfoCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var logOutButton: UIButton = {
        let button = ReusableButton(title: "Log Out", onAction: logOutButtonTapped,
                                                 cornerRad: 20, bgColor: .primaryHighlight, titleColor: .white, titleSize: 20, titleFont: "Nexa-Bold")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let viewModel: ProfileViewModel?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
    }
    
    override func configureView() {
        view.backgroundColor = .backgroundMain
        configureNavigationBar()
    
        view.addSubViews(loadingView, profileIcon, infoCollectionView, logOutButton)
        view.bringSubviewToFront(loadingView)
    }
    
    override func configureConstraint() {
        loadingView.fillSuperviewSafeAreaLayoutGuide()
        
        profileIcon.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            padding: .init(all: 16)
        )
        profileIcon.anchorSize(.init(width: 120, height: 120))
        profileIcon.centerXToSuperview()
        
        infoCollectionView.anchor(
            top: profileIcon.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: .init(all: 12)
        )
        infoCollectionView.anchorSize(.init(width: 0, height: 148))
        
        logOutButton.anchor(
            top: infoCollectionView.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: .init(all: 24)
        )
        logOutButton.anchorSize(.init(width: 0, height: 48))
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
                case .error(message: let message):
                    self.showMessage(title: message)
                }
            }
        }
    }
    
    init(viewModel: ProfileViewModel?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configureNavigationBar() {
        let navgationView = UIView()
        navgationView.translatesAutoresizingMaskIntoConstraints = false
        let label = UILabel()
        label.text = "Profile"
        label.sizeToFit()
        label.textAlignment = .center
        label.font = UIFont(name: "Nexa-Bold", size: 20)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
       
        navgationView.addSubview(label)
        label.centerXToView(to: navgationView)
        label.centerYToView(to: navgationView)

        navigationItem.titleView = navgationView

        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        navigationController?.navigationBar.tintColor = .primaryHighlight
    }
    
    @objc private func logOutButtonTapped() {
        UserDefaults.standard.set("", forKey: "username")
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        viewModel?.showLaunchScreen()
    }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return infoList.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileInfoCollectionViewCell", for: indexPath) as? ProfileInfoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let field = infoList.allCases[indexPath.row]
        cell.configureCell(title: field)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 8, height: 72)
        
    }
}
