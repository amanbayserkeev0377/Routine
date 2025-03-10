import SwiftUI

struct SelectUnitView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedUnit: String
    
    @State private var units = ["count", "steps", "min", "hr", "km", "mile", "sec", "ml", "oz", "Cal", "g", "mg", "drink"]
    @State private var customUnits: [String] = UserDefaults.standard.stringArray(forKey: "customUnits") ?? []
    @State private var showTextField = false
    @State private var customUnit = ""
    @State private var isEditing = false
    
    var body: some View {
        NavigationView {
            VStack {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                    
                    // units
                    ForEach(units, id: \.self) { unit in
                        Button(action: {
                            selectedUnit = unit
                            dismiss()
                        }) {
                            Text(unit)
                                .font(.headline)
                                .foregroundStyle(selectedUnit == unit ? .white : .black)
                                .frame(maxWidth: .infinity, minHeight: 40)
                                .background(selectedUnit == unit ? Color.black : Color(.systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    
                    // custom units
                    ForEach(customUnits, id: \.self) { unit in
                        HStack {
                            Button(action: {
                                selectedUnit = unit
                                dismiss()
                            }) {
                                Text(unit)
                                    .font(.headline)
                                    .foregroundStyle(selectedUnit == unit ? .white : .black)
                                    .frame(maxWidth: .infinity, minHeight: 40)
                                    .background(selectedUnit == unit ? Color.black : Color(.systemGray6))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            
                            if isEditing {
                                Button(action: {
                                    deleteCustomUnit(unit)
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundStyle(.red)
                                }
                            }
                        }
                    }
                    
                    Button(action: {
                        showTextField.toggle()
                    }) {
                        Text("+")
                            .font(.headline)
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding()
                
                if showTextField {
                    TextField("Enter custom unit", text: $customUnit, onCommit: addCustomUnit)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .keyboardType(.default)
                        .submitLabel(.done)
                }
                
                Spacer()
            }
            .navigationTitle("Select Unit")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(.black)
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(isEditing ? "Done" : "Edit") {
                        isEditing.toggle()
                    }
                    .foregroundStyle(.black)
                }
            }
            .presentationDetents([.medium])
        }
    }
    
    private func addCustomUnit() {
        let trimmedUnit = customUnit.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedUnit.isEmpty, !units.contains(trimmedUnit), !customUnits.contains(trimmedUnit) else { return }
        
        customUnits.append(trimmedUnit)
        UserDefaults.standard.set(customUnits, forKey: "customUnits")
        selectedUnit = trimmedUnit
        customUnit = ""
        showTextField = false
    }
    
    private func deleteCustomUnit(_ unit: String) {
        customUnits.removeAll { $0 == unit }
        UserDefaults.standard.set(customUnits, forKey: "customUnits")
    }
}

#Preview {
    SelectUnitView(selectedUnit: .constant("steps"))
}
