//
//  LoginViewController.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 30.12.24.
//

import UIKit

final class LoginViewController: BaseViewController {
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .white
        view.tintColor = .white
        view.hidesWhenStopped = true
        view.backgroundColor = .backgroundMain
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
        view.addSubViews(loadingView)
        view.bringSubviewToFront(loadingView)
    }
    
    fileprivate func configureNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    
    override func configureConstraint() {
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
                case .success:
                    print(#function)
//                    self.listCollectionView.reloadSections(.init(arrayLiteral: 1,2,3,4,5))
                case .error(let error):
                    self.showMessage(title: "Error", message: error)
                }
            }
        }
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
        label.centerToYView(to: navigationView)

        navigationItem.titleView = navigationView
    }
}
