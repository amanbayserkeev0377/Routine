import SwiftUI

struct HabitDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    let habit: Habit
    
    @State private var isTimerRunning = false
    @State private var remainingTime: Int = 0
    @State private var elapsedTime: Int = 0
    @State private var timer: Timer?
    @State private var currentValue: Int64
    
    init(habit: Habit) {
        self.habit = habit
        _currentValue = State(initialValue: habit.goalValue)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text(habit.name ?? "Unnamed habit")
                .font(.title)
                .bold()
            
            if isTimeBasedHabit {
                timerView()
            } else {
                counterView()
            }
            
            Button("Complete habit") {
                markAsCompleted()
            }
            .font(.headline)
            .foregroundStyle(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.black)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Spacer()
            
        }
        .padding()
        .onAppear {
            setupTimer()
        }
    }
    
    private var isTimeBasedHabit: Bool {
        ["min", "hr", "sec"].contains(habit.unit)
    }
    
    private func counterView() -> some View {
        VStack(spacing: 20) {
            Text("\(currentValue) \(habit.unit ?? "")")
                .font(.largeTitle)
                .bold()
            
            HStack(spacing: 40) {
                Button(action: decrementValue) {
                    Image(systemName: "minus.circle.fill")
                        .font(.largeTitle)
                        .foregroundStyle(currentValue > 0 ? .black : .gray)
                }
                .disabled(currentValue == 0)
                
                Button(action: incrementValue) {
                    Image(systemName: "plus.circle.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                }
            }
        }
    }
    
    private func incrementValue() {
        currentValue += 1
        saveHabitValue()
    }
    
    private func decrementValue() {
        if currentValue > 0 {
            currentValue -= 1
            saveHabitValue()
        }
    }
    
    private func saveHabitValue() {
        habit.goalValue = currentValue
        do {
            try viewContext.save()
        } catch {
            print("Error saving value: \(error.localizedDescription)")
        }
    }
    
    private func setupTimer() {
        if isTimeBasedHabit, let goal = Int(exactly: habit.goalValue) {
            remainingTime = goal * timeMultiplier(for: habit.unit ?? "min")
            elapsedTime = 0
        }
    }
    
    private func timeMultiplier(for unit: String) -> Int {
        switch unit {
        case "hr": return 3600
        case "min": return 60
        case "sec": return 1
        default: return 60
        }
    }
    
    private func timerView() -> some View {
        VStack(spacing: 15) {
            CircularProgressView(progress: progress)
            
            Text("\(formattedTime(remainingTime))")
                .font(.largeTitle)
                .bold()
                .padding()
            
            HStack {
                Button(action: startTimer) {
                    Image(systemName: "play.circle.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                }
                .disabled(isTimerRunning)
                
                Button(action: stopTimer) {
                    Image(systemName: "stop.circle.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.red)
                }
                .disabled(!isTimerRunning)
            }
        }
    }
    
    private var progress: CGFloat {
        guard remainingTime > 0 else { return 0 }
        return CGFloat(elapsedTime) / CGFloat(remainingTime + elapsedTime)
    }
    
    private func placeholderView() -> some View {
        Text("There will be UI for other types of habits")
            .font(.subheadline)
            .foregroundStyle(.gray)
    }
    
    private func startTimer() {
        isTimerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if remainingTime > 0 {
                remainingTime -= 1
                elapsedTime += 1
            } else {
                stopTimer()
            }
        }
    }
    
    private func stopTimer() {
        isTimerRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    private func formattedTime(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = seconds % 60
        
        if hours > 0 {
            return String(format: "%02:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
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
