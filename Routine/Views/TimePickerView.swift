import SwiftUI

struct TimePickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedTime: Int
    @Binding var selectedUnit: String
    @State private var inputTime: String = ""
    
    let timeUnits = ["sec", "min", "hr"]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Add Time")
                .font(.title2)
                .bold()
            
            HStack {
                TextField("0", text: $inputTime)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .frame(width: 80, height: 44)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Picker("Unit", selection: $selectedUnit) {
                    ForEach(timeUnits, id: \.self) { unit in
                        Text(unit).tag(unit)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 150)
            }
            
            Button("Add") {
                if let time = Int(inputTime) {
                    selectedTime += convertToSeconds(time: time, unit: selectedUnit)
                }
                dismiss()
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
        .presentationDetents([.medium])
    }
    
    private func convertToSeconds(time: Int, unit: String) -> Int {
        switch unit {
        case "hr": return time * 3600
        case "min": return time * 60
        case "sec": return time
        default: return time
        }
    }
}

#Preview {
    TimePickerView(selectedTime: .constant(30), selectedUnit: .constant("min"))
}
