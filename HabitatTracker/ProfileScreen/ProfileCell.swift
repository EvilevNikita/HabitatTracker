//
//  ProfileCell.swift
//  HabitatTracker
//
//  Created by Георгий Матченко on 20.05.2023.
//

import UIKit
import SnapKit

class ProfileCell: UITableViewCell {
    static let reuseId: String = "ProfileCell"
    
    private lazy var logoBackground: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .orange
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 5
        imageView.tintColor = .myOtherColor
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .myOtherColor
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Some cell"
        return label
    }()
    
    private lazy var rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.left")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .myOtherColor
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(logoBackground)
        contentView.addSubview(logoImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(rightImageView)
        setConstraintsSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraintsSubviews() {
        logoBackground.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(50)
            make.leading.equalTo(40)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(35)
            make.width.equalTo(35)
            make.centerX.equalTo(logoBackground.snp.centerX)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(logoBackground.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }
        
        rightImageView.snp.makeConstraints { make in
            make.trailing.equalTo(-40)
            make.height.equalTo(25)
            make.width.equalTo(25)
            make.centerY.equalToSuperview()
        }
    }
}

extension ProfileCell: PassInfoToAny {
    func passInfo<T>(info: T) {
        if let info = info as? (text: String, image: UIImage) {
            titleLabel.text = info.text
            logoImageView.image = info.image
        }
    }
}
