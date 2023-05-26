//
//  HabitManager.swift
//  HabitatTracker
//
//  Created by Nikita Ivlev on 21/5/23.
//

import Foundation
import CoreData

class HabitManager {
    static let shared = HabitManager()
    let context = CoreDataManager.shared.context

    private init() {}

    func getHabitsCount() -> Int {
        let fetchRequest: NSFetchRequest<ManagedHabit> = ManagedHabit.fetchRequest()
        do {
            let habitsCount = try context.count(for: fetchRequest)
            return habitsCount
        } catch {
            print("Failed to fetch habits count: \(error)")
            return 0
        }
    }

    func getHabit(at index: Int) -> Habit? {
        let fetchRequest: NSFetchRequest<ManagedHabit> = ManagedHabit.fetchRequest()
        fetchRequest.fetchOffset = index
        fetchRequest.fetchLimit = 1
        do {
            let managedHabit = try context.fetch(fetchRequest).first
            return managedHabit.map(Habit.init)
        } catch {
            print("Failed to fetch habit at index \(index): \(error)")
            return nil
        }
    }

    func getHabits() -> [Habit] {
        let fetchRequest: NSFetchRequest<ManagedHabit> = ManagedHabit.fetchRequest()
        do {
            let managedHabits = try context.fetch(fetchRequest)
            return managedHabits.map(Habit.init)
        } catch {
            print("Failed to fetch habits: \(error)")
            return []
        }
    }

    func getHabitProgress(at index: Int) -> Double {
        guard let habit = getHabit(at: index) else { return 0.0 }

        let recordsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ManagedHabitRecord")
        let predicate = NSPredicate(format: "habit == %@", habit.id)
        recordsFetchRequest.predicate = predicate

        do {
            let totalRecordsCount = try context.count(for: recordsFetchRequest)

            let expenseFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ManagedHabitRecord")
            expenseFetchRequest.predicate = predicate
            expenseFetchRequest.resultType = .dictionaryResultType

            let sumExpressionDesc = NSExpressionDescription()
            sumExpressionDesc.name = "sum"
            sumExpressionDesc.expression = NSExpression(forKeyPath: "@sum.expense")
            sumExpressionDesc.expressionResultType = .doubleAttributeType

            expenseFetchRequest.propertiesToFetch = [sumExpressionDesc]

            let results = try context.fetch(expenseFetchRequest)
            let totalExpenses = (results.first as? NSDictionary)?.value(forKey: "sum") as? Double ?? 0.0

            let progress = (Double(habit.goal) - totalExpenses) / Double(habit.goal)

            return progress
        } catch {
            print(error.localizedDescription)
            return 0.0
        }
    }

    func getTotalProgress() -> Double {
        let habits = getHabits()
        let totalProgress = Double(habits.reduce(0) { $0 + $1.progressPercentage }) / Double(habits.count)
        return Double(totalProgress)
    }

    func getFinishedHabits() -> [Habit] {
        let fetchRequest: NSFetchRequest<ManagedHabit> = ManagedHabit.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "progress >= goal")
        do {
            let managedHabits = try context.fetch(fetchRequest)
            return managedHabits.map(Habit.init)
        } catch {
            print("Failed to fetch finished habits: \(error)")
            return []
        }
    }


    func saveHabit(name: String, goal: Int, startDate: Date, endDate: Date, frequency: Frequency) {
        guard let entity = NSEntityDescription.entity(forEntityName: "ManagedHabit", in: context) else { return }
        let managedHabit = ManagedHabit(entity: entity, insertInto: context)
        managedHabit.name = name
        managedHabit.goal = Int16(goal)
        managedHabit.start = startDate
        managedHabit.finish = endDate
        managedHabit.frequency = frequency.rawValue
        managedHabit.id = UUID().uuidString

        saveContext()
    }

    func updateHabit(_ habit: Habit) {
        let fetchRequest: NSFetchRequest<ManagedHabit> = ManagedHabit.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", habit.id)
        do {
            if let managedHabit = try context.fetch(fetchRequest).first {
                managedHabit.name = habit.name
                managedHabit.goal = Int16(habit.goal)
                managedHabit.start = habit.start
                managedHabit.finish = habit.finish
                managedHabit.frequency = habit.frequency.rawValue
                saveContext()
            } else {
                print("Habit not found")
            }
        } catch {
            print("Failed to update habit: \(error)")
        }
    }

    func saveProgressForHabit(_ habit: Habit, progress: Int, date: Date) {
        let record = ManagedHabitRecord(context: context)
        record.date = date
        record.progress = Int16(progress)

        if let managedHabit = getManagedHabit(id: habit.id) {
            managedHabit.progress = Int16(progress)
            record.habit = managedHabit
        } else {
            let managedHabit = ManagedHabit(context: context)
            managedHabit.id = habit.id
            managedHabit.name = habit.name
            managedHabit.goal = Int16(habit.goal)
            managedHabit.start = habit.start
            managedHabit.finish = habit.finish
            managedHabit.frequency = habit.frequency.rawValue
            managedHabit.progress = Int16(progress)
            record.habit = managedHabit
        }
        saveContext()
    }

    func getManagedHabit(id: String) -> ManagedHabit? {
        let fetchRequest: NSFetchRequest<ManagedHabit> = ManagedHabit.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let managedHabits = try context.fetch(fetchRequest)
            return managedHabits.first
        } catch {
            print("Failed to fetch ManagedHabit with id \(id): \(error)")
            return nil
        }
    }

    func getProgressForHabit(_ habit: Habit) -> [ManagedHabitRecord] {
        guard let managedHabit = getManagedHabit(id: habit.id) else {
            print("Failed to fetch ManagedHabit with id \(habit.id)")
            return []
        }

        let fetchRequest: NSFetchRequest<ManagedHabitRecord> = ManagedHabitRecord.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "habit == %@", managedHabit)
        do {
            let records = try context.fetch(fetchRequest)
            return records
        } catch {
            print("Failed to fetch progress records for habit with id \(habit.id): \(error)")
            return []
        }
    }

    func deleteHabit(at index: Int) {
        let fetchRequest: NSFetchRequest<ManagedHabit> = ManagedHabit.fetchRequest()
        fetchRequest.fetchOffset = index
        fetchRequest.fetchLimit = 1
        do {
            if let managedHabit = try context.fetch(fetchRequest).first {
                context.delete(managedHabit)
                saveContext()
            }
        } catch {
            print("Failed to delete habit at index \(index): \(error)")
        }
    }

    private func saveContext() {
        CoreDataManager.shared.saveContext()
    }

    func resetDailyProgress() {
        let habits = getHabits()
        for habit in habits {
            habit.progress = 0
        }
        saveContext()
    }

    func createDailyRecord() {
        let habits = getHabits()
        for habit in habits {
            guard let managedHabit = getManagedHabit(id: habit.id) else { continue }
            let record = ManagedHabitRecord(context: context)
            record.date = Date()
            record.progress = 0
            managedHabit.addToHabitRecords(record)
        }
        saveContext()
    }
}

