import SwiftUI

// контент внутри каждого предмета текущих

struct SubjectRowView: View {
    let subject: SubjectData
    @State private var isExpanded = false
    
    var body: some View {
        VStack(spacing: 0) {
            header
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isExpanded.toggle()
                    }
                }
            
            ZStack {
                if isExpanded {
                    VStack(spacing: 12) {
                        ForEach(subject.lessons) { lesson in
                            gradeItem(lesson: lesson)
                        }
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .clipped()
        }
    }
    
    // шапка конкретного предмета
    
    var header: some View {
        HStack(alignment: .center) {
            Text(subject.name)
                .font(.title2)
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)

            
            Text(subject.progress)
                .font(.subheadline)
                .foregroundColor(.black.opacity(0.5))
                .padding(.leading, 4)
                .padding(.top, 4)
            
            Spacer(minLength: 20)
            
            Image(systemName: "chevron.right")
                .font(.title2)
                .rotationEffect(.degrees(isExpanded ? 90 : 0))
                .foregroundColor(.gray)

        }
        .padding(.vertical, 10)
    }
    
    // один урок (семинар, лекция, рк и тп)
    
    private func gradeItem(lesson: Lesson) -> some View {
        
        // определим что за предмет
        
        let special: Bool = {
            let title = lesson.title.lowercased()
            return title.contains("лаб") || title.contains("рубеж")
        }()

        return VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(lesson.title)
                    .fontWeight(special ? .semibold : .regular) // bold
                    .lineLimit(nil)
                
                Spacer()

                Text(lesson.status)
                    .foregroundColor(lesson.statusColor)
            }

            Text(lesson.date)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}
