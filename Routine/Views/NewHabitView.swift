import SwiftUI

struct NewHabitView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var habitName: String = ""
    @State private var goalValue: String = ""
    @State private var unit: String = "count"
    @State private var showSelectUnit = false
    @State private var activeDays: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    let weekDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                habitNameField()
                goalInput()
                activeDaysSelector()
                Spacer()
            }
            .padding(.horizontal)
            .navigationTitle("New Habit")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(.black)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveHabit()
                    }
                    .foregroundStyle(.black)
                    .disabled(habitName.isEmpty || goalValue.isEmpty || activeDays.isEmpty)
                }
            }
            .sheet(isPresented: $showSelectUnit) {
                SelectUnitView(selectedUnit: $unit)
                    .presentationDetents([.medium])
            }
        }
    }
    
    private func habitNameField() -> some View {
        TextField("Habit name", text: $habitName)
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private func goalInput() -> some View {
        HStack {
            TextField("0", text: $goalValue)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.center)
                .padding(.vertical, 10)
                .frame(width: 55)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Button(action: { showSelectUnit.toggle() }) {
                Text(unit)
                    .foregroundColor(.black)
                    .padding(.horizontal)
                    .frame(width: 90, height: 40)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }
    
    private func activeDaysSelector() -> some View {
        VStack(alignment: .leading) {
            Text("Active days")
                .font(.headline)
            HStack {
                ForEach(weekDays, id: \.self) { day in
                    Button(action: {
                        toggleDaySelection(day)
                    }) {
                        Text(day)
                            .frame(width: 45, height: 40)
                            .background(activeDays.contains(day) ? Color.black : Color(.systemGray6))
                            .foregroundStyle(activeDays.contains(day) ? .white : .black)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
        }
    }
    
    private func toggleDaySelection(_ day: String) {
        if activeDays.contains(day) {
            activeDays.removeAll { $0 == day }
        } else {
            activeDays.append(day)
        }
    }

    private func saveHabit() {
        guard let goal = Int64(goalValue) else { return }
        
        let newHabit = Habit(context: viewContext)
        newHabit.name = habitName
        newHabit.goalValue = goal
        newHabit.unit = unit
        newHabit.timestamp = Date()
        newHabit.isCompleted = false
        newHabit.repeatFrequency = activeDays.joined(separator: ",")
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Error saving habit: \(error.localizedDescription)")
        }
    }
}

#Preview {
    NewHabitView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
