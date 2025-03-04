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
        let button = ReusableButton(
            title: "Login",
            onAction: { [weak self] in self?.loginButtonClicked() },
            cornerRad: 20,
            bgColor: .primaryHighlight,
            titleColor: .white,
            titleSize: 20,
            titleFont: "Nexa-Bold")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var signupButton: UIButton = {
        let button = ReusableButton(
            title: "Sign Up",
            onAction: { [weak self] in self?.signupButtonClicked() },
            cornerRad: 20,
            bgColor: .primaryHighlight,
            titleColor: .white,
            titleSize: 20,
            titleFont: "Nexa-Bold")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var continueWithLabel: UILabel = {
        let label = ReusableLabel(
            labelText: "Or continue with",
            labelColor: .white,
            labelFont: "NexaRegular",
            labelSize: 16
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var googleSignupButton: UIButton = {
        let button = ReusableButton(title: "Google",
                                    onAction: { [weak self] in self?.googleLoginButtonTapped() },
                                    cornerRad: 20,
                                    bgColor: .primaryHighlight
        )
        button.clipsToBounds = true
        button.tintColor = .white
        button.contentHorizontalAlignment = .left
        
        let image = UIImage(named: "googleSymbol")
        let resizedImage = image?.resizeImage(to: CGSize(width: 44, height: 24))
        button.setImage(resizedImage, for: .normal)

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [loginButton, signupButton])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var viewModel: LaunchViewModel?
    
    init(viewModel: LaunchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        viewModel?.requestCallback = nil
        viewModel = nil
        print("deinit \(self)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        
        UserDefaultsHelper.setString(key: .email, value: "")
        UserDefaultsHelper.setString(key: .username, value: "")
        UserDefaultsHelper.setString(key: .guestSessionID, value: "")
    }
    
    override func configureView() {
        configureNavigationBar()
        
        view.backgroundColor = .backgroundMain
        view.addSubViews(loadingView, logoImageView, buttonStack, continueWithLabel, googleSignupButton)
        view.bringSubviewToFront(loadingView)
    }
    
    fileprivate func configureNavigationBar() {
        navigationController?.isNavigationBarHidden = true
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
        
        
        continueWithLabel.centerXToSuperview()
        continueWithLabel.anchor(
            top: buttonStack.bottomAnchor,
            padding: .init(all: 32)
        )
        googleSignupButton.anchor(
            top: continueWithLabel.bottomAnchor,
            padding: .init(top: 12, left: 0, bottom: 0, right: 0)
        )
        googleSignupButton.anchorSize(.init(width: 112, height: 48))
        googleSignupButton.centerXToSuperview()
    }
    
    @objc fileprivate func loginButtonClicked() {
        viewModel?.showLoginController()
    }
    
    @objc fileprivate func signupButtonClicked() {
        viewModel?.showSignupController()
    }
    
    @objc fileprivate func googleLoginButtonTapped() {
        viewModel?.createUserWithGoogle(viewController: self)
    }
    
    private func configureViewModel() {
        viewModel?.requestCallback = { [weak self] state in
            guard let self = self else {return}
            DispatchQueue.main.async { [weak self] in
                switch state {
                case .loaded:
                    self?.loadingView.startAnimating()
                case .loading:
                    self?.loadingView.stopAnimating()
                case .success:
                    self?.viewModel?.startHomeScreen()
                case .error(let error):
                    self?.showMessage(title: "Error", message: error)
                    self?.loadingView.stopAnimating()
                }
            }
        }
    }
}
