//
//  ManagedHabitRecord+CoreDataProperties.swift
//  HabitatTracker
//
//  Created by Nikita Ivlev on 25/5/23.
//
//

import Foundation
import CoreData


extension ManagedHabitRecord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedHabitRecord> {
        return NSFetchRequest<ManagedHabitRecord>(entityName: "ManagedHabitRecord")
    }

    @NSManaged public var date: Date?
    @NSManaged public var progress: Int16
    @NSManaged public var habit: ManagedHabit?

}

extension ManagedHabitRecord : Identifiable {

}
