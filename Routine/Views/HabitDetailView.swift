import SwiftUI

struct HabitDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    let habit: Habit
    
    @State private var isTimerRunning = false
    @State private var remainingTime: Int = 0
    @State private var lastTimeValue: Int = 0
    @State private var timer: Timer?
    @State private var showTimePicker = false
    @State private var selectedUnit = "min"
    
    
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
        .presentationDetents([.fraction(0.75)])
        .onAppear {
            setupTimer()
        }
    }
    
    private var isTimeBasedHabit: Bool {
        ["min", "hr", "sec"].contains(habit.unit)
    }
    
    private func timerView() -> some View {
        VStack(spacing: 15) {
            CircularProgressView(progress: progress)
            
            Text("\(formattedTime(remainingTime))")
                .font(.largeTitle)
                .bold()
                .padding()
            
            HStack(spacing: 30) {
                Button(action: { remainingTime = lastTimeValue }) {
                    Image(systemName: "arrow.uturn.backward")
                        .font(.system(size: 25))
                        .foregroundStyle(.black)
                }
                
                Button(action: toggleTimer) {
                    Image(systemName: isTimerRunning ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 65))
                        .foregroundStyle(.black)
                }
                
                Button(action: { showTimePicker.toggle() }) {
                    Image(systemName: "plus")
                        .font(.system(size: 25))
                        .foregroundStyle(.black)
                }
            }
            
            HStack(spacing: 20) {
                Button(action: { subtractTime(30) }) {
                    Text("-30")
                        .font(.headline)
                        .padding()
                        .frame(width: 65)
                        .background(Color.black)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                
                Button(action: { subtractTime(10) }) {
                    Text("-10")
                        .font(.headline)
                        .padding()
                        .frame(width: 65)
                        .background(Color.black)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                
                Button(action: { addTime(10) }) {
                    Text("+10")
                        .font(.headline)
                        .padding()
                        .frame(width: 65)
                        .background(Color.black)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                
                Button(action: { addTime(30) }) {
                    Text("+30")
                        .font(.headline)
                        .padding()
                        .frame(width: 65)
                        .background(Color.black)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                
                
            }
            .sheet(isPresented: $showTimePicker) {
                TimePickerView(selectedTime: $remainingTime, selectedUnit: $selectedUnit)
            }
        }
    }
    
    private func counterView() -> some View {
        Text("Здесь UI для других типов привычек")
            .font(.subheadline)
            .foregroundStyle(.gray)
    }
    
    private var progress: CGFloat {
        guard lastTimeValue > 0 else { return 0 }
        return CGFloat(lastTimeValue - remainingTime) / CGFloat(lastTimeValue)
    }
    
    private func setupTimer() {
        if isTimeBasedHabit, let goal = Int(exactly: habit.goalValue) {
            remainingTime = goal * timeMultiplier(for: habit.unit ?? "min")
            lastTimeValue = remainingTime
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
    
    private func toggleTimer() {
        isTimerRunning.toggle()
        if isTimerRunning {
            startTimer()
        } else {
            stopTimer()
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                stopTimer()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func addTime(_ seconds: Int) {
        remainingTime -= seconds
        if remainingTime < 0 { remainingTime = 0 }
    }
    
    private func subtractTime(_ seconds: Int) {
        remainingTime += seconds
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
    let context = PersistenceController.preview.container.viewContext
    let sampleHabit = Habit(context: context)
    sampleHabit.name = "Reading"
    sampleHabit.goalValue = 45
    sampleHabit.unit = "min"
    sampleHabit.isCompleted = false
    sampleHabit.timestamp = Date()
    
    return HabitDetailView(habit: sampleHabit)
        .environment(\.managedObjectContext, context)
}
