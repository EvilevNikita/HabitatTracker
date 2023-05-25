//
//  ManagedHabit+CoreDataProperties.swift
//  HabitatTracker
//
//  Created by Nikita Ivlev on 25/5/23.
//
//

import Foundation
import CoreData


extension ManagedHabit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedHabit> {
        return NSFetchRequest<ManagedHabit>(entityName: "ManagedHabit")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var goal: Int16
    @NSManaged public var progress: Int16
    @NSManaged public var start: Date?
    @NSManaged public var finish: Date?
    @NSManaged public var frequency: String?
    @NSManaged public var habitRecords: NSSet?

}

// MARK: Generated accessors for habitRecords
extension ManagedHabit {

    @objc(addHabitRecordsObject:)
    @NSManaged public func addToHabitRecords(_ value: ManagedHabitRecord)

    @objc(removeHabitRecordsObject:)
    @NSManaged public func removeFromHabitRecords(_ value: ManagedHabitRecord)

    @objc(addHabitRecords:)
    @NSManaged public func addToHabitRecords(_ values: NSSet)

    @objc(removeHabitRecords:)
    @NSManaged public func removeFromHabitRecords(_ values: NSSet)

}

extension ManagedHabit : Identifiable {

}
