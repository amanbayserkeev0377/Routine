import SwiftUI

struct NewHabitView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var habitName: String = ""
    @State private var repeatFrequency: String = "Every day"
    @State private var goalValue: Int = 1
    @State private var unit: String = "count"
    @State private var showSelectUnit = false
    
    let repeatOptions = ["Every day", "Every week", "Every month"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                habitNameField()
                repeatPicker()
                goalSelection()
                saveButton()
                
                Spacer()
            }
            .padding(.horizontal)
            .navigationTitle("New Habit")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
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
    
    private func repeatPicker() -> some View {
        Picker("Repeat", selection: $repeatFrequency) {
            ForEach(repeatOptions, id: \.self) { option in
                Text(option).tag(option)
            }
        }
        .pickerStyle(.segmented)
    }
    
    private func goalSelection() -> some View {
        HStack {
            Stepper(value: $goalValue, in: 1...100) {
                Text("Goal: \(goalValue)")
            }
            
            Button(action: { showSelectUnit.toggle() }) {
                Text(unit)
                    .foregroundColor(.black)
                    .padding(.horizontal)
                    .frame(height: 30)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
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
        let newHabit = Habit(context: viewContext)
        newHabit.name = habitName
        newHabit.repeatFrequency = repeatFrequency
        newHabit.goalValue = Int64(goalValue)
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
