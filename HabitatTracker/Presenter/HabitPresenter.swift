//
//  HabitPresenter.swift
//  HabitatTracker
//
//  Created by Nikita Ivlev on 21/5/23.
//

import Foundation

protocol HabitPresenterProtocol: AnyObject {
    var view: HabitViewProtocol? { get }
    func getHabitsCount() -> Int
    func getHabit(at index: Int) -> Habit?
    func getHabits() -> [Habit]
    func getFinishedHabits() -> [Habit]
    func getHabitProgress(at index: Int) -> Double
    func getTotalProgress() -> Double
    func saveHabit(name: String, goal: Int, startDate: Date, endDate: Date, frequency: Frequency)
    func updateProgressHabit(at index: Int, with progress: Int)
    func deleteHabit(at index: Int)
    func updateHabitDetails(at index: Int, name: String, goal: Int, startDate: Date, endDate: Date, frequency: Frequency)
}

class HabitPresenter: HabitPresenterProtocol {

    weak var view: HabitViewProtocol?
    var habitManager: HabitManager

    init(view: HabitViewProtocol, habitManager: HabitManager) {
        self.view = view
        self.habitManager = habitManager
    }

    func getHabitsCount() -> Int {
        return habitManager.getHabits().count
    }

    func getHabit(at index: Int) -> Habit? {
        return habitManager.getHabit(at: index)
    }

    func getHabits() -> [Habit] {
        return habitManager.getHabits()
    }

    func getFinishedHabits() -> [Habit] {
        return habitManager.getFinishedHabits()
    }

    func getHabitProgress(at index: Int) -> Double {
        return habitManager.getHabitProgress(at: index)
    }

    func getTotalProgress() -> Double {
        return habitManager.getTotalProgress()
    }

    func saveHabit(name: String, goal: Int, startDate: Date, endDate: Date, frequency: Frequency) {
        habitManager.saveHabit(name: name, goal: goal, startDate: startDate, endDate: endDate, frequency: frequency)
        view?.refreshHabitsView()
    }
    
    func updateProgressHabit(at index: Int, with progress: Int) {
        if let habit = getHabit(at: index) {
            habitManager.saveProgressForHabit(habit, progress: progress, date: Date())
        }
    }

    func deleteHabit(at index: Int) {
        habitManager.deleteHabit(at: index)
        view?.refreshHabitsView()
    }

    func updateHabitDetails(at index: Int, name: String, goal: Int, startDate: Date, endDate: Date, frequency: Frequency) {
        if let habit = getHabit(at: index) {
            habit.name = name
            habit.goal = goal
            habit.start = startDate
            habit.finish = endDate
            habit.frequency = frequency
            habitManager.updateHabit(habit)
        }
    }
}
