//
//  User.swift
//  HabitatTracker
//
//  Created by Nikita Ivlev on 20/5/23.
//

import UIKit

class User {
    static let shared = User()

    var name = "Юзер"
    var profileImage: UIImage?

    private init() {}
}
