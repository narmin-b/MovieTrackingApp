//
//  SignupViewController.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 30.12.24.
//

import UIKit

final class SignupViewController: BaseViewController {
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .white
        view.tintColor = .white
        view.hidesWhenStopped = true
        view.backgroundColor = .backgroundMain
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = ReusableLabel(labelText: "Email", labelColor: .white, labelFont: "NexaRegular", labelSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emailTextfield: UITextField = {
        let textfield = ReusableTextField(placeholder: "Email", iconName: "envelope", placeholderFont: "NexaRegular", iconSetting: 6, iconTintColor: .accentMain, cornerRadius: 20, borderColor: .clear)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private lazy var emailStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailLabel, emailTextfield])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = ReusableLabel(labelText: "Username", labelColor: .white, labelFont: "NexaRegular", labelSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var usernameTextfield: UITextField = {
        let textfield = ReusableTextField(placeholder: "Username", iconName: "person", placeholderFont: "NexaRegular", iconTintColor: .accentMain, cornerRadius: 20, borderColor: .clear)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private lazy var usernameStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [usernameLabel, usernameTextfield])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var passwordLabel: UILabel = {
        let label = ReusableLabel(labelText: "Password", labelColor: .white, labelFont: "NexaRegular", labelSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var passwordTextfield: UITextField = {
        let textfield = ReusableTextField(placeholder: "Password", iconName: "lock", placeholderFont: "NexaRegular", iconTintColor: .accentMain, cornerRadius: 20, borderColor: .clear)
        
        let rightIcon = UIImageView(image: UIImage(systemName: "eye.fill"))
        rightIcon.tintColor = .accentMain
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: rightIcon.frame.height))
        rightIcon.frame = CGRect(x: -5, y: 0, width: rightIcon.frame.width, height: rightIcon.frame.height)
        rightPaddingView.addSubview(rightIcon)
        
        textfield.rightView = rightPaddingView
        textfield.rightViewMode = .always
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        rightIcon.isUserInteractionEnabled = true
        rightIcon.addGestureRecognizer(tapGestureRecognizer)
        
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private lazy var passwordStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [passwordLabel, passwordTextfield])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var singupInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailStackView, usernameStackView, passwordStackView])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var signupButton: UIButton = {
        let button = ReusableButton(title: "Sign Up", onAction: signupButtonClicked,
                                    cornerRad: 20, bgColor: .primaryHighlight, titleColor: .white, titleSize: 20, titleFont: "Nexa-Bold")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var loginLabel: UILabel = {
        let label = ReusableLabel(labelText: "Already have an account?", labelColor: .white, labelFont: "NexaRegular", labelSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var loginButton: UIButton = {
        let button = ReusableButton(title: "Login", onAction: loginButtonTapped, bgColor: .clear, titleColor: .primaryHighlight, titleSize: 16, titleFont: "Nexa-Bold")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var loginStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [loginLabel, loginButton])
        stack.axis = .horizontal
        stack.spacing = 2
        stack.alignment = .center
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let viewModel: SignupViewModel
    
    init(viewModel: SignupViewModel) {
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
        view.addSubViews(loadingView, singupInfoStackView, signupButton, loginStack)
        view.bringSubviewToFront(loadingView)
    }
    
    fileprivate func configureNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    override func configureConstraint() {
        loadingView.fillSuperviewSafeAreaLayoutGuide()
        
        singupInfoStackView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: view.frame.height/8, left: 24, bottom: 0, right: -24)
        )
        
        emailTextfield.anchorSize(.init(width: 0, height: 48))
        usernameTextfield.anchorSize(.init(width: 0, height: 48))
        passwordTextfield.anchorSize(.init(width: 0, height: 48))
        
        signupButton.anchor(
            top: singupInfoStackView.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 32, left: 24, bottom: 0, right: -24)
        )
        signupButton.anchorSize(.init(width: 0, height: 48))
        
        loginStack.anchor(
            top: signupButton.bottomAnchor,
            padding: .init(all: 12)
        )
        loginStack.centerXToSuperview()
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
                case .error(let error):
                    self.showMessage(title: "Error", message: error)
                }
            }
        }
    }
    
    @objc fileprivate func signupButtonClicked() {
        viewModel.createUser(email: emailTextfield.text!, password: passwordTextfield.text!, username: usernameTextfield.text!)
    }
    
    @objc fileprivate func imageTapped(_ tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as? UIImageView
        
        tappedImage?.image = UIImage(systemName: passwordTextfield.isSecureTextEntry ? "eye.fill" : "eye.slash.fill")
        passwordTextfield.isSecureTextEntry.toggle()
    }
    
    @objc fileprivate func loginButtonTapped() {
        print(#function)
//        navigationController?.popViewController(animated: true)
    }
}
