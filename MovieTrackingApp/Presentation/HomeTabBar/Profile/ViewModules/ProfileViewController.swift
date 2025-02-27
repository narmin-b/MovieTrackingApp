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
        imageview.isUserInteractionEnabled = true
        imageview.layer.borderWidth = 1
        imageview.layer.borderColor = UIColor.lightGray.cgColor
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageview.addGestureRecognizer(tapGesture)
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
        let button = ReusableButton(
            title: "Log Out",
            onAction: { [weak self] in self?.logOutButtonTapped() },
            cornerRad: 20,
            bgColor: .primaryHighlight,
            titleColor: .white,
            titleSize: 20,
            titleFont: "Nexa-Bold"
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let viewModel: ProfileViewModel?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
    }
    
    override func configureView() {
        configureProfile()
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
                    self.viewModel?.showLaunchScreen()
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
    
    deinit {
        viewModel?.requestCallback = nil
    }
    
    fileprivate func configureNavigationBar() {
        navigationItem.configureNavigationBar(text: "Profile")
        navigationController?.navigationBar.tintColor = .primaryHighlight
    }
    
    fileprivate func configureProfile() {
        profileIcon.image = viewModel?.loadProfilePictureFromDocuments()
    }
    
    @objc private func logOutButtonTapped() {
        UserDefaults.standard.set("", forKey: "username")
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        viewModel?.LogUserOut()
    }
    
    @objc fileprivate func imageTapped() {
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

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        UserDefaultsHelper.setString(key: .profileImage, value: "userProfile.jpeg")
        saveImageToDocuments(image: image, fileNameWithExtension: "userProfile.jpeg")
        profileIcon.image = image
        self.dismiss(animated: true)
    }
}
