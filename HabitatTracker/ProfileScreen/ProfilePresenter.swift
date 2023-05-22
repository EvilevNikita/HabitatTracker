//
//  ProfilePresenter.swift
//  HabitatTracker
//
//  Created by Георгий Матченко on 20.05.2023.
//

import Foundation

class ProfilePresenter {
//    static let shared = ProfilePresenter()
    
    let user = User(name: "George", color: .device, language: "Russian")
    
    weak private var delegate: ProfileProtocol?
    
    public func setViewToDelegate(view: ProfileProtocol?) {
        self.delegate = view
    }

    func logOut() {
    }
    
    
}
