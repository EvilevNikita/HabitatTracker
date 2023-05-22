//
//  ProfileHeader.swift
//  HabitatTracker
//
//  Created by Георгий Матченко on 20.05.2023.
//

import UIKit
import SnapKit

class ProfileHeader: UITableViewHeaderFooterView {
    static let reuseId: String = "ProfileHeader"
    weak var passInfoBack: PassInfoBack?
    private let heightScreen = UIScreen.main.bounds.height
    
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "default-user")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var changePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        let title = NSLocalizedString("Chage photo", comment: "change photo button")
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(changePhoto), for: .touchUpInside)
        button.tintColor = .systemGray
        return button
    }()
    
    @objc func changePhoto() {
        passInfoBack?.passInfo(info: true)
    }
    
    private lazy var nameTaxtfield: UITextField = {
        let textFiled = UITextField()
        textFiled.text = "Profile name"
        textFiled.addTarget(self, action: #selector(enterText), for: .editingDidEndOnExit)
        textFiled.textAlignment = .center
        return textFiled
    }()
    
    @objc func enterText() {
        nameTaxtfield.endEditing(true)
        passInfoBack?.passInfo(info: nameTaxtfield.text)
    }
    
    private lazy var segmentedControll: UISegmentedControl = {
        let segmentedControll = UISegmentedControl()
        let device = NSLocalizedString("Device", comment: "device mode")
        let light = NSLocalizedString("Light", comment: "light mode")
        let dark = NSLocalizedString("Dark", comment: "dark mode")
        segmentedControll.insertSegment(withTitle: device, at: 0, animated: true)
        segmentedControll.insertSegment(withTitle: light, at: 1, animated: true)
        segmentedControll.insertSegment(withTitle: dark, at: 2, animated: true)
        segmentedControll.selectedSegmentTintColor = .orange
        segmentedControll.selectedSegmentIndex = 0
        segmentedControll.addTarget(self, action: #selector(changeMode), for: .valueChanged)
        return segmentedControll
    }()
    
    @objc func changeMode() {
        passInfoBack?.passInfo(info: segmentedControll.selectedSegmentIndex)
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addSubview(photoImageView)
        addSubview(changePhotoButton)
        addSubview(nameTaxtfield)
        addSubview(segmentedControll)
        setConstraintsSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraintsSubviews() {
        photoImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.height.equalTo(heightScreen * 0.1)
            make.width.equalTo(heightScreen * 0.1)
            make.centerX.equalToSuperview()
        }
        
        changePhotoButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(photoImageView.snp.bottom).offset(5)
        }
        
        nameTaxtfield.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(changePhotoButton.snp.bottom).offset(5)
        }
        
        segmentedControll.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameTaxtfield.snp.bottom).offset(10)
            make.width.equalToSuperview().inset(30)
        }
    }
    
}

extension ProfileHeader: PassSettingsForHeaderProfile {
    func headerSettings(user: User) {
        photoImageView.image = user.image
        nameTaxtfield.text = user.name
        segmentedControll.selectedSegmentIndex = user.selectedTheme.rawValue
    }
}
