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
    private lazy var onboardingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height * 0.7)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(OnboardingViewCell.self, forCellWithReuseIdentifier: "OnboardingViewCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .gray
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private lazy var nextButton: UIButton = {
        let button = ReusableButton(
            title: "Next",
            onAction: { [weak self] in self?.nextButtonTapped() },
            cornerRad: 20,
            bgColor: .primaryHighlight,
            titleColor: .white,
            titleSize: 20,
            titleFont: "Nexa-Bold"
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let viewModel: OnboardingViewModel?
    
    private var slides: [OnboardingSlide] = [
        OnboardingSlide(title: "Welcome", subtitle: "Track your favorite movies easily!", image: UIImage(systemName: "film") ?? UIImage()),
        OnboardingSlide(title: "Discover", subtitle: "Find top-rated movies and trending content.", image: UIImage(systemName: "star") ?? UIImage()),
        OnboardingSlide(title: "Start Now", subtitle: "Sign up and begin your movie journey!", image: UIImage(systemName: "person") ?? UIImage())
    ]
    
    private var currentIndex: Int = 0
    
    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit \(self)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func configureView() {
        view.backgroundColor = .backgroundMain
        view.addSubViews(onboardingCollectionView, pageControl, nextButton)
        
        onboardingCollectionView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: -120, right: 0)
        )

        pageControl.centerXToSuperview()
        pageControl.anchor(
            top: onboardingCollectionView.bottomAnchor,
            padding: .init(top: 8)
        )

        nextButton.centerXToSuperview()
        nextButton.anchor(
            top: pageControl.bottomAnchor,
            leading: view.leadingAnchor,
//            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 8, left: 16, bottom: 0, right: -16)
        )
        nextButton.anchorSize(.init(width: 0, height: 48))
    }
    
    @objc private func nextButtonTapped() {
        let nextPage = currentIndex + 1
        if nextPage < slides.count {
            let indexPath = IndexPath(item: nextPage, section: 0)
            onboardingCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            currentIndex = nextPage
            pageControl.currentPage = nextPage
        } else {
            viewModel?.showLaunchController()
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
        cell.configureCell(slide: slides[indexPath.row])
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / view.frame.width)
        currentIndex = pageIndex
        pageControl.currentPage = pageIndex
    }
}
