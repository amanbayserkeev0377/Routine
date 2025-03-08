import SwiftUI

struct NewHabitView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var habitName: String = ""
    @State private var repeatFrequency: String = "Every day"
    @State private var goalValue: String = ""
    @State private var unit: String = "count"
    @State private var showSelectUnit = false
    
    let repeatOptions = ["Every day", "Every week", "Every month"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                habitNameField()
                goalInput()
                repeatPicker()
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
                    .disabled(habitName.isEmpty || goalValue.isEmpty)
                }
            }
            .sheet(isPresented: $showSelectUnit) {
                SelectUnitView(selectedUnit: $unit)
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
                .frame(width: 50)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Button(action: { showSelectUnit.toggle() }) {
                Text(unit)
                    .foregroundColor(.black)
                    .padding(.horizontal)
                    .frame(width: 80, height: 40)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }
    
    private func repeatPicker() -> some View {
        Picker("Repeat", selection: $repeatFrequency) {
            ForEach(repeatOptions, id: \.self) { option in
                Text(option).tag(option)
            }
        }
        .pickerStyle(.segmented)
    }
    
    private func saveButton() -> some View {
        Button(action: saveHabit) {
            Text("Save")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(habitName.isEmpty ? Color.gray : Color.black)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .disabled(habitName.isEmpty)
    }
    
    private func saveHabit() {
        guard let goal = Int64(goalValue) else { return }
        
        let newHabit = Habit(context: viewContext)
        newHabit.name = habitName
        newHabit.repeatFrequency = repeatFrequency
        newHabit.goalValue = goal
        newHabit.unit = unit
        newHabit.timestamp = Date()
        newHabit.isCompleted = false
        
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
