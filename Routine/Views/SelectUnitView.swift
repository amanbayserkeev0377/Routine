import SwiftUI

struct SelectUnitView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedUnit: String
    
    @State private var units = ["count", "cycles", "pages", "sec", "min", "hr", "steps", "mile", "km", "ml", "oz", "Сal", "mg", "g", "drink"]
    @State private var customUnits: [String] = UserDefaults.standard.stringArray(forKey: "customUnits") ?? []
    @State private var showTextField = false
    @State private var customUnit = ""
    @State private var isEditing = false
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                        
                        // standart units
                        ForEach(units, id: \.self) { unit in
                            Button(action: {
                                selectedUnit = unit
                                dismiss()
                            }) {
                                Text(unit)
                                    .font(.headline)
                                    .foregroundStyle(selectedUnit == unit ? .white : .black)
                                    .frame(minWidth: 60, maxWidth: .infinity, minHeight: 40)
                                    .background(selectedUnit == unit ? Color.black : Color(.systemGray6))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                        
                        // custom units
                        ForEach(customUnits, id: \.self) { unit in
                            ZStack(alignment: .topTrailing) {
                                Button(action: {
                                    selectedUnit = unit
                                    dismiss()
                                }) {
                                    Text(unit)
                                        .font(.headline)
                                        .foregroundStyle(selectedUnit == unit ? .white : .black)
                                        .padding()
                                        .frame(minWidth: 60, maxWidth: .infinity, minHeight: 40)
                                        .background(selectedUnit == unit ? Color.black : Color(.systemGray6))
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                
                                if isEditing {
                                    Button(action: {
                                        deleteCustomUnit(unit)
                                    }) {
                                        Image(systemName: "xmark")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundStyle(.white)
                                            .padding(4)
                                            .background(Color.black)
                                            .clipShape(Circle())
                                    }
                                    .offset(x: 6, y: -6)
                                }
                            }
                        }
                        
                        Button(action: {
                            showTextField.toggle()
                        }) {
                            Text("+")
                                .font(.headline)
                                .foregroundStyle(.black)
                                .frame(minWidth: 60, maxWidth: .infinity, minHeight: 40)
                                .background(Color(.systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .padding()
                }
                
                if showTextField {
                    HStack {
                        TextField("Enter custom unit", text: $customUnit)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding()
                            .frame(height: 44)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        Button(action: addCustomUnit) {
                            Image(systemName: "checkmark")
                                .font(.title2)
                                .foregroundStyle(customUnit.isEmpty ? .gray : .black)
                        }
                        .disabled(customUnit.isEmpty)
                    }
                    .padding(.horizontal)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
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
