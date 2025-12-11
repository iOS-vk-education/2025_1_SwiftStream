import SwiftUI

// шапка экрана (название + вкладки)

struct GradesHatView: View {
    @Binding var selectedTab: Grades.Tab
    
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Text("Успеваемость")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.black)
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
        .frame(maxWidth: .infinity)
    }
    
    // анимация кнопок вкладок
    
    private func gradesTabButton(title: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(isActive ? .white : .black)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(
                    Capsule()
                        .fill(isActive ? Color.systemblue : .white)
                        .overlay(
                            Capsule()
                                .stroke(Color.black.opacity(isActive ? 0 : 0.5), lineWidth: 1)
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
