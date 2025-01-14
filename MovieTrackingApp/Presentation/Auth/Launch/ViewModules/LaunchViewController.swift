//
//  LaunchViewController.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 30.12.24.
//

import UIKit

final class LaunchViewController: BaseViewController {
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .white
        view.tintColor = .white
        view.hidesWhenStopped = true
        view.backgroundColor = .backgroundMain
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var logoImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "logoMain"))
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var loginButton: UIButton = {
        let button = ReusableButton(title: "Login", onAction: loginButtonClicked,
                                    cornerRad: 20, bgColor: .primaryHighlight, titleColor: .white, titleSize: 20, titleFont: "Nexa-Bold")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var signupButton: UIButton = {
        let button = ReusableButton(title: "Sign Up", onAction: signupButtonClicked,
                                    cornerRad: 20, bgColor: .primaryHighlight, titleColor: .white, titleSize: 20, titleFont: "Nexa-Bold")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var googleSignupButton: UIButton = {
        let button = ReusableButton(title: "", onAction: googleLoginButtonTapped,
                                    cornerRad: 20, bgColor: .primaryHighlight)
        button.clipsToBounds = true

        let googleImageView = UIImageView(image: UIImage(named: "googleLogo"))
        googleImageView.contentMode = .scaleAspectFit
        googleImageView.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(googleImageView)

        googleImageView.centerXToView(to: button)
        googleImageView.centerToView(to: button)
        googleImageView.widthAnchor.constraint(equalTo: button.widthAnchor, multiplier: 0.7).isActive = true
        googleImageView.heightAnchor.constraint(equalTo: button.heightAnchor, multiplier: 0.7).isActive = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [loginButton, signupButton, googleSignupButton])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let viewModel: LaunchViewModel
    
    init(viewModel: LaunchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        
        UserDefaultsHelper.setString(key: "email", value: "")
        UserDefaultsHelper.setString(key: "username", value: "")
    }
    
    override func configureView() {
        configureNavigationBar()
        
        view.backgroundColor = .backgroundMain
        view.addSubViews(loadingView, logoImageView, buttonStack)
        view.bringSubviewToFront(loadingView)
    }
    
    fileprivate func configureNavigationBar() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    override func configureConstraint() {
        loadingView.fillSuperviewSafeAreaLayoutGuide()
        
        logoImageView.centerXToSuperview()
        logoImageView.anchorSize(.init(width: 0, height: view.frame.height/4.5))
        logoImageView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            padding: .init(top: view.frame.height/5.5, left: 0, bottom: 0, right: 0)
        )
        
        buttonStack.anchor(
            top: logoImageView.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 16, left: 24, bottom: 0, right: -24)
        )
        loginButton.anchorSize(.init(width: 0, height: 48))
        signupButton.anchorSize(.init(width: 0, height: 48))
        googleSignupButton.anchorSize(.init(width: 0, height: 48))

    }
    
    @objc fileprivate func loginButtonClicked() {
        viewModel.showLoginController()
    }
    
    @objc fileprivate func signupButtonClicked() {
        viewModel.showSignupController()
    }
    
    @objc fileprivate func googleLoginButtonTapped() {
        viewModel.createUserWithGoogle(viewController: self)
    }
    
    private func configureViewModel() {
        viewModel.requestCallback = { [weak self] state in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch state {
                case .loaded:
                    self.loadingView.startAnimating()
                case .loading:
                    self.loadingView.stopAnimating()
                case .success:
                    self.viewModel.startHomeScreen()
                case .error(let error):
                    self.showMessage(title: "Error", message: error)
                    self.loadingView.stopAnimating()
                }
            }
        }
    }
}
