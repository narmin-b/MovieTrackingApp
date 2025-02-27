//
//  SignupViewController.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 30.12.24.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import GoogleSignIn

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

    private lazy var titleLabel: UILabel = {
        let label = ReusableLabel(
            labelText: "Create An Account!",
            labelColor: .white,
            labelFont: "Nexa-Bold",
            labelSize: 32
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var profileIcon: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "testing")
        imageview.contentMode = .scaleToFill
        imageview.layer.cornerRadius = 40
        imageview.layer.masksToBounds = true
        imageview.isUserInteractionEnabled = true
        imageview.layer.borderWidth = 1
        imageview.layer.borderColor = UIColor.lightGray.cgColor
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profImageTapped))
        imageview.addGestureRecognizer(tapGesture)
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = ReusableLabel(
            labelText: "Email",
            labelColor: .white,
            labelFont: "NexaRegular",
            labelSize: 20
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emailTextfield: UITextField = {
        let textfield = ReusableTextField(
            placeholder: "Email",
            iconName: "envelope",
            placeholderFont: "NexaRegular",
            iconSetting: 6,
            iconTintColor: .accentMain,
            cornerRadius: 20,
            borderColor: .clear
        )
        textfield.inputAccessoryView = doneToolBar
        textfield.textColor = .black
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
        let label = ReusableLabel(
            labelText: "Username",
            labelColor: .white,
            labelFont: "NexaRegular",
            labelSize: 20
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var usernameTextfield: UITextField = {
        let textfield = ReusableTextField(
            placeholder: "Username",
            iconName: "person",
            placeholderFont: "NexaRegular",
            iconTintColor: .accentMain,
            cornerRadius: 20,
            borderColor: .clear
        )
        textfield.inputAccessoryView = doneToolBar
        textfield.textColor = .black
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
        let label = ReusableLabel(
            labelText: "Password",
            labelColor: .white,
            labelFont: "NexaRegular",
            labelSize: 20
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var passwordTextfield: UITextField = {
        let textfield = ReusableTextField(
            placeholder: "Password",
            iconName: "lock",
            placeholderFont: "NexaRegular",
            iconTintColor: .accentMain,
            cornerRadius: 20,
            borderColor: .clear
        )
        textfield.delegate = self
        
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
        
        textfield.inputAccessoryView = doneToolBar
        textfield.textColor = .black
        textfield.isSecureTextEntry = true
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private lazy var passReqLabel: UILabel = {
        let label = ReusableLabel(
            labelText: "• Must Contain 6 Characters",
            labelColor: .white,
            labelFont: "NexaRegular",
            labelSize: 12
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var passUpcaseReqLabel: UILabel = {
        let label = ReusableLabel(
            labelText: "• Must Contain An Uppercase",
            labelColor: .white,
            labelFont: "NexaRegular",
            labelSize: 12
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var passNumReqLabel: UILabel = {
        let label = ReusableLabel(
            labelText: "• Must Contain A Number",
            labelColor: .white,
            labelFont: "NexaRegular",
            labelSize: 12
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var passwordRequirementsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [passReqLabel, passUpcaseReqLabel, passNumReqLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
        let button = ReusableButton(
            title: "Sign Up",
            onAction: { [weak self] in self?.signupButtonClicked() },
            cornerRad: 20,
            bgColor: .primaryHighlight,
            titleColor: .white,
            titleSize: 20,
            titleFont: "Nexa-Bold"
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var loginLabel: UILabel = {
        let label = ReusableLabel(
            labelText: "Already have an account?",
            labelColor: .white,
            labelFont: "NexaRegular",
            labelSize: 16
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var loginButton: UIButton = {
        let button = ReusableButton(
            title: "Login",
            onAction: { [weak self] in self?.loginButtonTapped() },
            bgColor: .clear,
            titleColor: .primaryHighlight,
            titleSize: 16,
            titleFont: "Nexa-Bold"
        )
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
    
    private lazy var doneToolBar: UIToolbar = {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        keyboardToolbar.translatesAutoresizingMaskIntoConstraints = true
        return keyboardToolbar
    }()
    
    private let viewModel: SignupViewModel?
    
    init(viewModel: SignupViewModel) {
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
        removeErrorBorder()
    }
    
    override func configureView() {
        configureNavigationBar()
        
        view.backgroundColor = .backgroundMain
        view.addSubViews(loadingView, titleLabel, profileIcon, singupInfoStackView, passwordRequirementsStack, signupButton, loginStack)
        view.bringSubviewToFront(loadingView)
    }
    
    fileprivate func configureNavigationBar() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        navigationController?.navigationBar.tintColor = .primaryHighlight
    }
    
    
    override func configureConstraint() {
        loadingView.fillSuperviewSafeAreaLayoutGuide()
       
        titleLabel.centerXToSuperview()
        titleLabel.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            padding: .init(all: 12)
        )
        
        profileIcon.centerXToSuperview()
        profileIcon.anchorSize(.init(width: 80, height: 80))
        profileIcon.anchor(
            top: titleLabel.bottomAnchor,
            padding: .init(all: 12)
        )
        
        singupInfoStackView.anchor(
            top: profileIcon.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 12, left: 24, bottom: 0, right: -24)
        )
        
        emailTextfield.anchorSize(.init(width: 0, height: 48))
        usernameTextfield.anchorSize(.init(width: 0, height: 48))
        passwordTextfield.anchorSize(.init(width: 0, height: 48))
        
        passwordRequirementsStack.anchor(
            top: singupInfoStackView.bottomAnchor,
            leading: view.leadingAnchor,
            padding: .init(top: 8, left: 28, bottom: 0, right: 0)
        )
        
        signupButton.anchor(
            top: passwordRequirementsStack.bottomAnchor,
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
        viewModel?.requestCallback = { [weak self] state in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch state {
                case .loading:
                    self.loadingView.startAnimating()
                case .loaded:
                    self.loadingView.stopAnimating()
                case .success:
                    self.viewModel?.popController()
                    self.showMessage(title: "User created", message: "User created successfully.")
                    self.textfieldCleaning()
                case .error(let error):
                    self.showMessage(title: "Error", message: error)
                }
            }
        }
    }
    
    @objc fileprivate func imageTapped(_ tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as? UIImageView
        
        tappedImage?.image = UIImage(systemName: passwordTextfield.isSecureTextEntry ? "eye.fill" : "eye.slash.fill")
        passwordTextfield.isSecureTextEntry.toggle()
    }
    
    @objc fileprivate func loginButtonTapped() {
        viewModel?.showLoginScreen()
    }
    
    @objc fileprivate func signupButtonClicked() {
        checkInputRequirements()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    fileprivate func removeErrorBorder() {
        usernameTextfield.errorBorderOff()
        emailTextfield.errorBorderOff()
        passwordTextfield.errorBorderOff()
    }
    
//    fileprivate func createUserWithPassword(email: String, password: String, username: String) {
//        viewModel?.createUser(email: email, password: password, username: username, profileImage: <#UIImage#>)
//    }
    
    fileprivate func checkInputRequirements() {
//        guard let usernameText = usernameTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines), let emailText = emailTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines), let passwordText = passwordTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
//        
//        if usernameText.isValidName() && emailText.isValidEmail() && passwordText.isValidPassword() {
//            createUserWithPassword(email: emailText, password: passwordText, username: usernameText)
//        } else {
//            checkErrorBorders(email: emailText, password: passwordText, username: usernameText)
//        }
        
        guard let usernameText = usernameTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  let emailText = emailTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  let passwordText = passwordTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  let profileImage = profileIcon.image else { return }

            if usernameText.isValidName() && emailText.isValidEmail() && passwordText.isValidPassword() {
                viewModel?.createUser(email: emailText, password: passwordText, username: usernameText, profileImage: profileImage)
            } else {
                checkErrorBorders(email: emailText, password: passwordText, username: usernameText)
            }
    }
    
    fileprivate func checkErrorBorders(email: String, password: String, username: String) {
        if !username.isValidName() {
            usernameTextfield.errorBorderOn()
        } else {
            usernameTextfield.errorBorderOff()
        }
        if !email.isValidEmail() {
            emailTextfield.errorBorderOn()
        } else {
            emailTextfield.errorBorderOff()
        }
        if !password.isValidPassword() {
            passwordTextfield.errorBorderOn()
        } else {
            passwordTextfield.errorBorderOff()
        }
    }
    
    fileprivate func checkPassWordRequirements() {
        let passwordText = passwordTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if passwordText.isValidPasswordMask() {
            passReqLabel.textColor = .systemGreen
        } else {
            passReqLabel.textColor = .white
        }
        if passwordText.doesContainDigit() {
            passNumReqLabel.textColor = .systemGreen
        } else {
            passNumReqLabel.textColor = .white
        }
        if passwordText.doesContainUppercase() {
            passUpcaseReqLabel.textColor = .systemGreen
        } else {
            passUpcaseReqLabel.textColor = .white
        }
    }
    
    fileprivate func textfieldCleaning() {
        emailTextfield.text = ""
        passwordTextfield.text = ""
        usernameTextfield.text = ""
    }
    
    @objc fileprivate func profImageTapped() {
        showImagePicker()
    }
    
    func imagePicker(sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        return imagePicker
    }
    
    func showImagePicker() {
        let alertVC = UIAlertController(title: "Choose a Picture", message: "Choose from Library or Camera", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] (action) in
            guard let self = self else { return }
            let cameraImagePicker = self.imagePicker(sourceType: .camera)
            cameraImagePicker.delegate = self
            self.present(cameraImagePicker, animated: true)
        }
        
        let libraryAction = UIAlertAction(title: "Library", style: .default) { [weak self] (action) in
            guard let self = self else { return }
            let libraryImagePicker = self.imagePicker(sourceType: .photoLibrary)
            libraryImagePicker.delegate = self
            self.present(libraryImagePicker, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertVC.addAction(cameraAction)
        alertVC.addAction(libraryAction)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func saveImageToDocuments(image: UIImage, fileNameWithExtension: String) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Failed to access the documents directory.")
            return
        }

        let imagePath = documentsDirectory.appendingPathComponent(fileNameWithExtension)

        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            print("Failed to convert UIImage to JPEG data.")
            return
        }

        do {
            try imageData.write(to: imagePath)
            print("Image successfully saved at: \(imagePath)")
        } catch {
            print("Error saving image to documents directory: \(error)")
        }
    }
}


extension SignupViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == passwordTextfield {
            checkPassWordRequirements()
        }
    }
}

extension SignupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        UserDefaultsHelper.setString(key: .profileImage, value: "userProfile.jpeg")
        saveImageToDocuments(image: image, fileNameWithExtension: "userProfile.jpeg")
        profileIcon.image = image
        self.dismiss(animated: true)
    }
}
