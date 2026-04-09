import SwiftUI

struct GradesHatView: View {
    @Binding var selectedTab: Grades.Tab
    
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Text(Translation.Grades.title)
                    .fontWeight(.bold)
                    .font(.system(size: 30))
                Spacer()
            }
            
            HStack(spacing: 24) {
                gradesTabButton(title: Translation.Grades.current, isActive: selectedTab == .current) {
                    selectedTab = .current
                }

                gradesTabButton(title: Translation.Grades.session, isActive: selectedTab == .session) {
                    selectedTab = .session
                }
            }
        }
        .padding()
        .padding(.top, 20)
        .frame(maxWidth: .infinity)
    }

    private func gradesTabButton(title: LocalizedStringKey, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(isActive ? Colors.white : Colors.black)
                .frame(width: 110)
                .padding(.vertical, 8)
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
        Group {
            BottomBarView(selectedTab: 3)
                .environmentObject(AppState())
                .environment(\.locale, Locale(identifier: "ru"))
                .previewDisplayName("Russian")
            
            BottomBarView(selectedTab: 3)
                .environmentObject(AppState())
                .environment(\.locale, Locale(identifier: "en"))
                .previewDisplayName("English")
            
            BottomBarView(selectedTab: 3)
                .environmentObject(AppState())
                .environment(\.locale, Locale(identifier: "zh-Hans"))
                .previewDisplayName("Chinese")
        }
    }
}
