import SwiftUI

struct HabitDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    let habit: Habit
    
    @State private var progress: Int = 0
    
    var body: some View {
        VStack(spacing: 20) {
            Text(habit.name ?? "Unnamed")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Daily goal: \(habit.goalValue) \(habit.unit ?? "")")
                .foregroundColor(.gray)
            
            HStack {
                Button(action: { decreaseProgress() }) {
                    Image(systemName: "minus.circle")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                }
                
                Text("\(progress)")
                    .font(.title)
                    .frame(width: 60)
                
                Button(action: { increaseProgress() }) {
                    Image(systemName: "plus.circle")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                }
            }
            
            Button(action: markAsCompleted) {
                Text("Complete")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .onAppear {
            progress = Int(habit.goalValue)
        }
    }
    
    private func increaseProgress() {
        habit.goalValue += 1
        saveContext()
    }
    
    private func decreaseProgress() {
        if habit.goalValue > 0 {
            habit.goalValue -= 1
            saveContext()
        }
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving progress: \(error.localizedDescription)")
        }
    }
    
    private func markAsCompleted() {
        habit.isCompleted = true
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Error saving completion: \(error.localizedDescription)")
        }
    }
}

#Preview {
    HabitDetailView(habit: Habit())
}
