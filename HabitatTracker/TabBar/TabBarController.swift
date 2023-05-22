//
//  TabBarController.swift
//  HabitatTracker
//
//  Created by Георгий Матченко on 22.05.2023.
//

import UIKit

class TabBarController: UITabBarController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = configureTabBar()
        self.navigationItem.hidesBackButton = true
        customizationTabBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureTabBar() -> [UIViewController]{
        var controllers: [UIViewController] = []
        
        let habitTitle = NSLocalizedString("Habits", comment: "habits tab bar")
        let mainViewController = UIViewController() // add controller
        mainViewController.tabBarItem = UITabBarItem(title: habitTitle, image: UIImage(systemName: "checklist"), selectedImage: UIImage(systemName: "checklist.checked"))
        controllers.append(mainViewController)
        
        let calendarTitle = NSLocalizedString("Calendar", comment: "calendar tab bar")
        let basketViewController =  UIViewController()  // add controller
        basketViewController.tabBarItem = UITabBarItem(title: calendarTitle, image: UIImage(systemName: "calendar"), selectedImage: UIImage(systemName: "calendar"))
        controllers.append(basketViewController)
        
        let profileTitle = NSLocalizedString("Profile", comment: "profile tab bar")
        let profileViewController = ProfileView(presenter: ProfilePresenter())
        profileViewController.tabBarItem = UITabBarItem(title: profileTitle, image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        controllers.append(profileViewController)
        
        return controllers
    }
    
    private func customizationTabBar() {
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = .myBackgorundColor
        
        let positionX: CGFloat = 2
        let positionY: CGFloat = 5
        let width = tabBar.bounds.width - (positionX * 2)
        let heigh = tabBar.bounds.height + (positionY * 2)

        let beziePath = UIBezierPath(roundedRect: CGRect(x: positionX, y: tabBar.bounds.minY - positionY, width: width, height: heigh), cornerRadius: width / 2)

        let roundLayer = CAShapeLayer()
        roundLayer.path = beziePath.cgPath
        let color = UIColor.orange.resolvedColor(with: self.traitCollection).cgColor
        roundLayer.fillColor = color

        tabBar.layer.insertSublayer(roundLayer, at: 0)
        tabBar.itemPositioning = .centered
        tabBar.tintColor = .myBackgorundColor
        tabBar.unselectedItemTintColor = .myOtherColor
    }
}
