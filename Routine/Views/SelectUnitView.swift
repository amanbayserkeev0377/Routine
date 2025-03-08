import SwiftUI

struct SelectUnitView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedUnit: String
    
    let units = ["count", "steps", "min", "hr", "km", "mile", "sec", "ml", "oz", "Cal", "g", "mg", "drink"]
    
    var body: some View {
        NavigationView {
            VStack {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                    ForEach(units, id: \.self) { unit in
                        Button(action: {
                            selectedUnit = unit
                            dismiss()
                        }) {
                            Text(unit)
                                .font(.headline)
                                .foregroundColor(selectedUnit == unit ? .white : .black)
                                .frame(maxWidth: .infinity, minHeight: 40)
                                .background(selectedUnit == unit ? Color.black : Color(.systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle("Select Unit")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SelectUnitView(selectedUnit: .constant("steps"))
}
