//
//  OnboardingViewController.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 05.02.25.
//

import UIKit

struct OnboardingSlide {
    let title: String
    let subtitle: String
    let image: UIImage
}

final class OnboardingViewController: BaseViewController {
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .white
        view.tintColor = .white
        view.hidesWhenStopped = true
        view.backgroundColor = .backgroundMain
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var onboardingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .red
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = false
        view.delegate = self
        view.register(cell: OnboardingViewCell.self)
        return view
    }()
    
//    private lazy var onboardingCollectionView: UIScrollView = {
//        let scrollView = UIScrollView(frame: self.view.bounds)
//        scrollView.isPagingEnabled = true
//        scrollView.contentSize = CGSize(width: view.bounds.width * CGFloat(images.count), height: view.bounds.height)
//        scrollView.showsHorizontalScrollIndicator = false
//        
//        scrollView.delegate = self
//        
//        for (index, image) in images.enumerated() {
//            let imageView = UIImageView(image: image)
//            imageView.contentMode = .scaleAspectFit
//            imageView.frame = CGRect(x: view.bounds.width * CGFloat(index), y: 0, width: view.bounds.width, height: view.bounds.height)
//            scrollView.addSubview(imageView)
//        }
//        return scrollView
//    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl(frame: CGRect(x: 0, y: view.bounds.height - 50, width: view.bounds.width, height: 50))
        pageControl.numberOfPages = images.count
        pageControl.currentPage = currentIndex
//        pageControl.addTarget(self, action: #selector(pageControlChanged(_:)), for: .valueChanged)
        return pageControl
    }()
    
    private lazy var nextButton: UIButton = {
        let button = ReusableButton(title: "Next", onAction: loginButtonClicked,
                                    cornerRad: 4, bgColor: .primaryHighlight, titleColor: .white, titleSize: 20, titleFont: "Nexa-Bold")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
//    private lazy var skipButton: UIButton = {
//        let button = ReusableButton(title: "Skip", onAction: loginButtonClicked,
//                                    bgColor: .clear, titleColor: .primaryHighlight, titleSize: 16, titleFont: "Nexa-Bold")
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
    
    private let viewModel: OnboardingViewModel?
    
    var slides: [OnboardingSlide] = [
        OnboardingSlide(title: "test1", subtitle: "jdfvbdbifbvidfbvd", image: UIImage(systemName: "house") ?? UIImage()),
        OnboardingSlide(title: "test2", subtitle: "jdfvbdbifbvidfbvd", image: UIImage(systemName: "star") ?? UIImage()),
        OnboardingSlide(title: "test3", subtitle: "jdfvbdbifbvidfbvd", image: UIImage(systemName: "person") ?? UIImage())
    ]
    
    var images: [UIImage] = [UIImage(systemName: "house")!, UIImage(systemName: "house")!, UIImage(systemName: "house")!]
    var currentIndex: Int = 0
    
    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        viewModel?.requestCallback = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        
    }
    
    override func configureView() {
        configureNavigationBar()
        
        view.backgroundColor = .backgroundMain
        view.addSubViews(loadingView, onboardingCollectionView, pageControl, nextButton)
        view.bringSubviewToFront(loadingView)
    }
    
    fileprivate func configureNavigationBar() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    override func configureConstraint() {
        loadingView.fillSuperviewSafeAreaLayoutGuide()
        
        onboardingCollectionView.anchor(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: -100, right: 0)
        )
        
        pageControl.centerXToSuperview()
        pageControl.anchor(
            top: onboardingCollectionView.bottomAnchor,
            padding: .init(all: 0)
        )
        
        nextButton.centerXToSuperview()
        nextButton.anchor(
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 16, bottom: -32, right: -16)
        )
        nextButton.anchorSize(.init(width: 0, height: 48))
            
//        skipButton.anchor(
//            top: view.safeAreaLayoutGuide.topAnchor,
//            trailing: view.trailingAnchor,
//            padding: .init(all: 4)
//        )
    }
    
    @objc fileprivate func loginButtonClicked() {
        viewModel?.showLoginController()
    }
    
    private func configureViewModel() {
        viewModel?.requestCallback = { [weak self] state in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch state {
                case .loaded:
                    self.loadingView.startAnimating()
                case .loading:
                    self.loadingView.stopAnimating()
                case .success:
                    self.viewModel?.startHomeScreen()
                case .error(let error):
                    self.showMessage(title: "Error", message: error)
                    self.loadingView.stopAnimating()
                }
            }
        }
    }
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingViewCell", for: indexPath) as? OnboardingViewCell else {
            return UICollectionViewCell()
        }
        cell.configureCell(slides[indexPath.row])
        return cell
    }
}
