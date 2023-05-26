//
//  Delegates.swift
//  HabitatTracker
//
//  Created by Георгий Матченко on 20.05.2023.
//

import Foundation
import UIKit

protocol PassInfoToAny: AnyObject {
    func passInfo<T>(info: T)
}

protocol PassInfoBack: AnyObject {
    func passInfo<T>(info: T)
}

protocol PassSettingsForHeaderProfile: AnyObject {
    func headerSettings(user: User)
}

protocol ProfileProtocol: AnyObject {}
