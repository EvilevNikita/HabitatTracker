//
//  User.swift
//  HabitatTracker
//
//  Created by Георгий Матченко on 20.05.2023.
//

import UIKit

class User {
    var name: String
    var selectedTheme: Theme
    var language: String
    var image: UIImage
    
    init(name: String, color: Theme = Theme.device, language: String, image: UIImage = UIImage(named: "default-user")!) {
        self.name = name
        self.selectedTheme = color
        self.language = language
        self.image = image
    }
}
