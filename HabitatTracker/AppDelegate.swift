//
//  AppDelegate.swift
//  HabitatTracker
//
//  Created by Nikita Ivlev on 19/5/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.

      // Calculate the time until 24:00
          let currentCalendar = Calendar.current
          let now = Date()
          let tomorrow = currentCalendar.date(byAdding: .day, value: 1, to: now)!
          let midnightTomorrow = currentCalendar.startOfDay(for: tomorrow)
          let timeUntilMidnight = midnightTomorrow.timeIntervalSince(now)

          // Schedule timer to fire at midnight (taking into account time until midnight)
          Timer.scheduledTimer(withTimeInterval: timeUntilMidnight, repeats: true) { (timer) in
              HabitManager.shared.resetDailyProgress()
          }
      
    return true
  }

  // MARK: UISceneSession Lifecycle

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }


}

