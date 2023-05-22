//
//  Theme.swift
//  HabitatTracker
//
//  Created by Георгий Матченко on 22.05.2023.
//

import UIKit

enum Theme: Int {
    case device
    case light
    case dark
    
    func getUserInterfaceStyle() -> UIUserInterfaceStyle {
        switch self {
        case .device:
            return .unspecified
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}
