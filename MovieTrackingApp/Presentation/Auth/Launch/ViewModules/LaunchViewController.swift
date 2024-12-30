//
//  LaunchViewController.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 30.12.24.
//

import UIKit

final class LaunchViewController: BaseViewController {
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
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [loginButton, signupButton])
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
    }
    
    override func configureView() {
        configureNavigationBar()
        
        view.backgroundColor = .backgroundMain
        view.addSubViews(logoImageView, buttonStack)
    }
    
    fileprivate func configureNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func configureConstraint() {
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
    }
    
    @objc fileprivate func loginButtonClicked() {
        viewModel.showLoginController()
    }
    
    @objc fileprivate func signupButtonClicked() {
        viewModel.showSignupController()
    }
    
    private func configureViewModel() {
        viewModel.requestCallback = { [weak self] state in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch state {
                case .success:
                    print(#function)
                case .error(let error):
                    self.showMessage(title: "Error", message: error)
                }
            }
        }
    }
}
