import SwiftUI

// шапка экрана (название + вкладки)

struct GradesHatView: View {
    @Binding var selectedTab: Grades.Tab
    
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Text("Успеваемость")
                    .fontWeight(.bold)
                    .font(.system(size: 30))
                Spacer()
            }
            
            HStack(spacing: 24) {
                gradesTabButton(title: "Текущая", isActive: selectedTab == .current) {
                    selectedTab = .current
                }
                gradesTabButton(title: "Сессия", isActive: selectedTab == .session) {
                    selectedTab = .session
                }
            }
        }
        .padding()
        .padding(.top, 20)
        .frame(maxWidth: .infinity)
        
        
        
    }
    
    // анимация кнопок вкладок
    private func gradesTabButton(title: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(isActive ? Colors.white : Colors.black)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(
                    Capsule()
                        .fill(isActive ? Colors.MainColor : Colors.white)
                        .overlay(
                            Capsule()
                                .stroke(Colors.black.opacity(isActive ? 0 : 0.5), lineWidth: 1)
                        )
                )
        }
    }
}

// маска (для шапки)
struct HorizontalInsetShape: Shape {
    var insetX: CGFloat

    func path(in rect: CGRect) -> Path {
        let frame = CGRect(
            x: rect.minX + insetX,
            y: rect.minY,
            width: rect.width - 2 * insetX,
            height: rect.height
        )
        var path = Path()
        path.addRect(frame)
        return path
    }
}




struct Grades_header_Previews: PreviewProvider {
    static var previews: some View {
        let appState = AppState()
        return BottomBarView(selectedTab: 3)
            .environmentObject(appState)
    }
}
