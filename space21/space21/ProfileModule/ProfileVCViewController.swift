//
//  ProfileVCViewController.swift
//  space21
//
//  Created by Марина on 17.11.2024.
//

import UIKit

class ProfileViewController: UIViewController {
    var userProfile: UserProfile
    
    let onboardingView = OnboardingView()
    lazy var profileView = ProfileView(userProfile: userProfile)
    
    init(userProfile: UserProfile) {
        self.userProfile = userProfile
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let jwt = NetworkManager.shared.getJWT() {
            setUpProfile(userProfile: userProfile)
           
        } else {
            setUpOnboarding()
        }
     
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Профиль"
        [profileView, onboardingView].forEach { view.addSubview($0)}
        [onboardingView, profileView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false}
        self.onboardingView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
      
    }
    
    func setUpProfile(userProfile: UserProfile) {
        onboardingView.isHidden = true
        profileView.isHidden = false
        let avatarURL = userProfile.avatar
            ImageCacheManager.shared.loadImage(from: avatarURL) { [weak self] image in
                guard let self = self else { return }
                if let image = image {
                    self.profileView.avatarImageView.image = image
                } else {
                    print("Failed to load avatar image")
                }
            }
        NSLayoutConstraint.activate([
            profileView.topAnchor.constraint(equalTo: view.topAnchor),
            profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        profileView.nameField.text = userProfile.nickname
        print(userProfile)
    }
    
    func setUpOnboarding() {
        profileView.isHidden = true
        NSLayoutConstraint.activate([
            onboardingView.topAnchor.constraint(equalTo: view.topAnchor),
            onboardingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            onboardingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            onboardingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func loginButtonTapped() {
        let login = onboardingView.loginTextField.text ?? "login"
        let password = onboardingView.passwordTextField.text ?? "password"
    
            NetworkManager.shared.loginRequest(username: login, password: password) { result in
                switch result {
                case .success(let data):
                    print("Response Data: \(data)")
    
                    if let jwt = NetworkManager.shared.getJWT() {
                        print("Saved JWT: \(jwt)")
                    }
                    NetworkManager.shared.getProfile(username: login) { result in
                        switch result {
                        case .success(let userProfile):
                            self.setUpProfile(userProfile: userProfile)
                            
                        case .failure(let error):
                            print("Error: \(error.localizedDescription)")
                            
                        }
                    }
    
                case .failure(let error):
                    self.presentALert(error.localizedDescription)
                }
            }
    
        }
    
    private func presentALert(_ error: String ) {
        DispatchQueue.main.async {
            let alertVC = GFAlertVC(alertTitle: "Возникла ошибка",
                                    message: error,
                                    buttonTitle: "Попробовать еще раз")
            
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
        @objc func dismissKeyboard() {
              view.endEditing(true)
          }
    
}
