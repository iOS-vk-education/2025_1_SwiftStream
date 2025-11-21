
import SwiftUI


struct MapView: View {
    @State private var fromLocation = ""
    @State private var toLocation = ""
    @State private var selectedFloor = "1"
    @State private var showingLowerFloors = true
    
    let lowerFloors = ["1", "2", "3", "4", "5", "6"]
    let upperFloors = ["7", "8", "9", "10", "11", "12"]
    
    var currentFloors: [String] {
        return showingLowerFloors ? lowerFloors : upperFloors
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Text("Навигатор")
                    .font(.system(size: 34, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 50)
                    .padding(.bottom, 30)
                
                VStack(spacing: 0) {
                    HStack(spacing: 8) {
                        ForEach(currentFloors, id: \.self) { floor in
                            Button(action: {
                                selectedFloor = floor
                            }) {
                                Text(floor)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(selectedFloor == floor ? .white : .primary)
                                    .frame(height: 32)
                                    .frame(maxWidth: .infinity)
                                    .background(selectedFloor == floor ? Color.blue : Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                            }
                            
                            if floor != currentFloors.last {
                                Text("|")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 14, weight: .medium))
                            }
                        }
                        
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                showingLowerFloors.toggle()
                                selectedFloor = showingLowerFloors ? "1" : "7"
                            }
                        }) {
                            Image(systemName: showingLowerFloors ? "chevron.down" : "chevron.up")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.blue)
                                .frame(width: 32, height: 32)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        .shadow(color: .gray.opacity(0.2), radius: 2, x: 0, y: 1)
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
                
                Image("Group8")
                    .frame(width: 365, height: 388)
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .padding(.bottom, 30)
                
                HStack(spacing: 16) {
                    CustomTextField(
                        text: $fromLocation,
                        placeholder: "Откуда"
                    )
                    
                    CustomTextField(
                        text: $toLocation,
                        placeholder: "Куда"
                    )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                
                Button(action: {
                    print("Построить маршрут: \(fromLocation) → \(toLocation) на этаже \(selectedFloor)")
                }) {
                    Text("Построить маршрут")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .disabled(fromLocation.isEmpty || toLocation.isEmpty)
                .opacity(fromLocation.isEmpty || toLocation.isEmpty ? 0.6 : 1.0)
                
                Spacer()
                    .frame(height: 80)
            }
            .navigationBarHidden(true)
        }
    }
}

struct CustomTextField: View {
    @Binding var text: String
    let placeholder: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            TextField("", text: $text)
                .focused($isFocused)
                .multilineTextAlignment(.center)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isFocused ? Color.blue : Color.gray.opacity(0.3), lineWidth: 1)
                )
            
            if text.isEmpty && !isFocused {
                Text(placeholder)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.clear)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        isFocused = true
                    }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .animation(.easeInOut(duration: 0.2), value: text.isEmpty)
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}


struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
