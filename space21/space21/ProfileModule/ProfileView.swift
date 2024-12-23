//
//  ProfileViewController.swift
//  space21
//
//  Created by Марина on 16.10.2024.
//

import UIKit
class ProfileView: UIView {
    
     let avatarImageView: UIImageView = {
        let avatarImageView = AvatarImageView(frame: .zero)
        avatarImageView.image = UIImage(systemName: "person")
        return avatarImageView
    }()
    
     let mainTitle: UILabel = {
        let label = UILabel()
        label.text = StringConstants.Profile.title
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
     let additionalTitle: UILabel = {
        let label = UILabel()
        label.text = StringConstants.Profile.additionalInfo
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
     let nameLabel = TextLabel(text: StringConstants.Profile.name)
    
     let birthLabel = TextLabel(text: StringConstants.Profile.birthDate)
    
     let cityLabel = TextLabel(text: StringConstants.Profile.city)
    
     let tgLabel = TextLabel(text: StringConstants.Profile.tg)
    
     let githubLabel = TextLabel(text: StringConstants.Profile.github)
    
     let osLabel = TextLabel(text: StringConstants.Profile.os)
    
     let workLabel = TextLabel(text: StringConstants.Profile.workPlace)
    
     let studyLabel = TextLabel(text: StringConstants.Profile.studyPlace)
    
     let skillsLabel = TextLabel(text: StringConstants.Profile.skills)
    
     let hobbiesLabel = TextLabel(text: StringConstants.Profile.hobby)
    
     lazy var nameField = CustomTextField(placeholderText: "")
     lazy var birthField = CustomTextField(placeholderText:  "")
     lazy var cityField = CustomTextField(placeholderText: "")
     lazy var tgField = CustomTextField(placeholderText: "")
    
    lazy var nameStack = LabelTextFieldStackView(arrangedSubviews: [nameLabel, nameField ])
     lazy var cityStack = LabelTextFieldStackView(arrangedSubviews: [cityLabel, cityField ])
     lazy var birthStack = LabelTextFieldStackView(arrangedSubviews: [birthLabel, birthField ])
     lazy var tgStack = LabelTextFieldStackView(arrangedSubviews: [tgLabel, tgField ])
    
     lazy var githubField = CustomTextField(placeholderText:  "")
     lazy var OSField = CustomTextField(placeholderText:  "")
     lazy var workField = CustomTextField(placeholderText: "")
     lazy var studyField = CustomTextField(placeholderText: "")
    lazy var skillsField = CustomTextField(placeholderText:  "Git, Kafka, Docker")
    lazy var hobbiesField = CustomTextField(placeholderText:  "Горные лыжи, Бег, книги")
    
    private lazy var githubStack = LabelTextFieldStackView(arrangedSubviews: [githubLabel, githubField ])
    private lazy var osStack = LabelTextFieldStackView(arrangedSubviews: [osLabel, OSField ])
    private lazy var workStack = LabelTextFieldStackView(arrangedSubviews: [workLabel, workField ])
    private lazy var studyStack = LabelTextFieldStackView(arrangedSubviews: [studyLabel, studyField ])
    private lazy var skillsStack = LabelTextFieldStackView(arrangedSubviews: [skillsLabel, skillsField ])
    private lazy var hobbiesStack = LabelTextFieldStackView(arrangedSubviews: [hobbiesLabel, hobbiesField ])






    
     lazy var mainStack = UIStackView(arrangedSubviews: [nameStack, birthStack, cityStack, tgStack],
                                             axis: .vertical,
                                             spacing: 5,
                                             alignment: .fill,
                                             distribution: .equalSpacing)
    
    
     lazy var additionalStack = UIStackView(arrangedSubviews: [githubStack, osStack, workStack, studyStack, skillsStack, hobbiesStack],
                                             axis: .vertical,
                                             spacing: 5,
                                             alignment: .fill,
                                             distribution: .equalSpacing)
    
    var userProfile: UserProfile?

    init(userProfile: UserProfile?) {
        self.userProfile = userProfile
        super.init(frame: .zero)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    private func setUpView() {
        
        self.backgroundColor = .white
  
        [avatarImageView, mainTitle, mainStack, additionalTitle, additionalStack].forEach { self.addSubview($0)}

        [avatarImageView, mainTitle, additionalTitle, additionalStack].forEach { $0.translatesAutoresizingMaskIntoConstraints = false}
        
        setUpConstraints()
    }
}

extension ProfileView{
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            avatarImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            
            mainTitle.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 10),
            mainTitle.leadingAnchor.constraint(equalTo:leadingAnchor, constant: 10),
            mainTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            mainStack.topAnchor.constraint(equalTo: mainTitle.bottomAnchor, constant: 10),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            mainStack.heightAnchor.constraint(equalToConstant: 200),
            
            additionalTitle.topAnchor.constraint(equalTo: mainStack.bottomAnchor, constant: 10),
            additionalTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            additionalTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            additionalStack.topAnchor.constraint(equalTo: additionalTitle.bottomAnchor, constant: 10),
            additionalStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            additionalStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            additionalStack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
