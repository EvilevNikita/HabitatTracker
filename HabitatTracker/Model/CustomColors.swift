//
//  CustomColors.swift
//  HabitatTracker
//
//  Created by Nikita Ivlev on 21/5/23.
//

import UIKit

extension UIColor {
    static let lightOrange: UIColor = UIColor(red: 255/255, green: 139/255, blue: 24/255, alpha: 1.0)
    static let darkOrange: UIColor = UIColor(red: 255/255, green: 75/255, blue: 0/255, alpha: 1.0)
    static let backgroundOrange: UIColor = UIColor(red: 255/255, green: 196/255, blue: 140/255, alpha: 1.0)
    static let customGreen: UIColor = UIColor(red: 56/255, green: 201/255, blue: 116/255, alpha: 1.0)

    func darker() -> UIColor {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        if self.getRed(&r, green: &g, blue: &b, alpha: &a){
            return UIColor(red: max(r - 0.1, 0.0), green: max(g - 0.1, 0.0), blue: max(b - 0.1, 0.0), alpha: a)
        }
        return self
    }
}
