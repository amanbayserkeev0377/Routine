//
//

import Foundation
import CoreData


extension Habit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Habit> {
        return NSFetchRequest<Habit>(entityName: "Habit")
    }

    @NSManaged public var timestamp: Date?
    @NSManaged public var name: String?
    @NSManaged public var goalValue: Int64
    @NSManaged public var unit: String?
    @NSManaged public var repeatFrequency: String?
    @NSManaged public var isCompleted: Bool

}

extension Habit : Identifiable {

}
