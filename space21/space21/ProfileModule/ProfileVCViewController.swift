//
//  ProfileVCViewController.swift
//  space21
//
//  Created by Марина on 17.11.2024.
//

import UIKit

class ProfileViewController: UIViewController {
    var userProfile: UserProfile?
    
    let onboardingView = OnboardingView()
    lazy var profileView = ProfileView(userProfile: nil)
    
    init(userProfile: UserProfile?) {
        self.userProfile = userProfile
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let loadedUser = loadUserSettings()
       
        if let jwt = NetworkManager.shared.getJWT() {
            setUpProfile(userProfile: loadedUser)
           
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
    
    func setUpProfile(userProfile: UserProfile?) {
        guard let userProfile = userProfile else { return }
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
        profileView.birthField.text = userProfile.birthdate
        profileView.cityField.text = userProfile.city
        profileView.tgField.text = userProfile.telegram
        profileView.githubField.text = userProfile.git
        profileView.OSField.text = userProfile.os
        profileView.workField.text = userProfile.work
        profileView.studyField.text = userProfile.university
        profileView.skillsField.text = userProfile.skills?.first
        profileView.hobbiesField.text = userProfile.hobbies?.first
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
    func saveUserSettings(_ settings: UserProfile) {
        let defaults = UserDefaults.standard
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(settings)
            defaults.set(data, forKey: "UserSettings")
        } catch {
            print("Failed to encode settings: \(error)")
        }
    }
    
    func loadUserSettings() -> UserProfile? {
        let defaults = UserDefaults.standard
        
        guard let data = defaults.data(forKey: "UserSettings") else { return nil }
        
        let decoder = JSONDecoder()
        do {
            let settings = try decoder.decode(UserProfile.self, from: data)
            return settings
        } catch {
            print("Failed to decode settings: \(error)")
            return nil
        }
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
                            self.saveUserSettings(userProfile)

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
