//
//  MovieDetailController.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 19.12.24.
//

import UIKit

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
    
    private let viewModel: MovieDetailViewModel?
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    fileprivate func configureNavigationBar() {
        let navgationView = UIView()
        navgationView.translatesAutoresizingMaskIntoConstraints = false
        let label = UILabel()
        label.text = "Movies"
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
    
    init(viewModel: MovieDetailViewModel?) {
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
                print(#function)

//                DispatchQueue.main.async {
//                    self.loadingView.startAnimating()
//                }
            case .loaded:
                print(#function)

//                DispatchQueue.main.async {
//                    self.loadingView.stopAnimating()
//                }
            case .success:
                print(#function)

//                DispatchQueue.main.async {
//                }
            case .error(message: let message):
                showMessage(title: message)
            }
        }
    }
    
    override func configureView() {
        view.backgroundColor = .purple
    }
    
    override func configureConstraint() {
        loadingView.centerXToSuperview()
        loadingView.centerYToSuperview()
    }
        
    override func configureTargets() {
        
    }
}
