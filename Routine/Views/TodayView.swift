import SwiftUI
import CoreData

struct TodayView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Habit.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Habit.timestamp, ascending: false)]
    ) private var habits: FetchedResults<Habit>
    
    @State private var showNewHabitView = false
    @State private var selectedHabit: Habit?
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(habits) { habit in
                        HabitRow(habit: habit)
                            .onTapGesture {
                                selectedHabit = habit
                            }
                    }
                    .onDelete(perform: deleteHabit)
                }
                .listStyle(.plain)
                HStack {
                    Spacer()
                    Button(action: {
                        showNewHabitView.toggle()
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 48, height: 48)
                            .background(Color.black)
                            .clipShape(Circle())
                            .shadow(radius: 2)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 10)
                }
                .sheet(isPresented: $showNewHabitView) {
                    NewHabitView()
                        .presentationDetents([.medium])
                }
            }
            .navigationTitle("Today")
            .sheet(item: $selectedHabit) { habit in
                HabitDetailView(habit: habit)
            }
        }
    }
    
    private func deleteHabit(at offsets: IndexSet) {
        for index in offsets {
            let habitToDelete = habits[index]
            viewContext.delete(habitToDelete)
        }
        do {
            try viewContext.save()
        } catch {
            print("Error deleting habit: \(error.localizedDescription)")
        }
    }
}

struct HabitRow: View {
    let habit: Habit
    
    var body: some View {
        HStack {
            Text(habit.name ?? "Unnamed")
                .font(.headline)
            Spacer()
            Image(systemName: habit.isCompleted ? "checkmark.circle.fill" : "checkmark.circle")
                .foregroundColor(habit.isCompleted ? .green : .gray)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    TodayView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
