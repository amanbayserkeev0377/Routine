import SwiftUI
import CoreData

class HabitViewModel: ObservableObject {
    @Published var habits: [Habit] = []
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        fetchHabits()
    }

    func fetchHabits() {
        let request: NSFetchRequest<Habit> = Habit.fetchRequest()
        do {
            habits = try context.fetch(request)
        } catch {
            print("Failed to fetch habits: \(error)")
        }
    }

    func addHabit(name: String, goal: Int64, unit: String, repeatFrequency: String) {
        let newHabit = Habit(context: context)
        newHabit.name = name
        newHabit.goalValue = goal
        newHabit.unit = unit
        newHabit.repeatFrequency = repeatFrequency
        newHabit.isCompleted = false
        newHabit.timestamp = Date()

        saveContext()
        fetchHabits()
    }
    
    func deleteHabit(_ habit: Habit) {
        context.delete(habit)
        saveContext()
        fetchHabits()
    }

    func completeHabit(_ habit: Habit) {
        habit.isCompleted = true
        saveContext()
        fetchHabits()
    }

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
