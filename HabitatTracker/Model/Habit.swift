//
//  Habit.swift
//  HabitatTracker
//
//  Created by Nikita Ivlev on 20/5/23.
//

import Foundation

class Habit: Identifiable {
    var id: String
    var name: String
    var goal: Int = 1
    var progress: Int = 0
    var progressPercentage: Double {
        if progress / goal <= 1 {
            return Double(progress) / Double(goal)
        } else {
            return 1
        }
    }

    var isFinished: Bool {
        return progressPercentage >= 1
    }
    var start: Date?
    var finish: Date?
    var frequency: Frequency = .daily

    init(from managedHabit: ManagedHabit) {
        self.id = managedHabit.id ?? ""
        self.name = managedHabit.name ?? ""
        self.goal = Int(managedHabit.goal)
        self.progress = Int(managedHabit.progress)
        self.start = managedHabit.start
        self.finish = managedHabit.finish
        self.frequency = Frequency(rawValue: managedHabit.frequency ?? "") ?? .daily
    }
}


enum Frequency: String, CaseIterable {
    case daily = "Ежедневно"
    case weekly = "Еженедельно"
    case monthly = "Ежемесячно"
}

