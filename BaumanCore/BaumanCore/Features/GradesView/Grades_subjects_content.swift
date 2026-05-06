import SwiftUI

struct SubjectRowView: View {
    let subject: SubjectData
    @Binding var expandedSubjectId: String?
    let languageCode: String
    
    private var isExpanded: Bool {
        expandedSubjectId == subject.id
    }
    
    var body: some View {
        VStack(spacing: 0) {
            header
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        if isExpanded {
                            expandedSubjectId = nil
                        } else {
                            expandedSubjectId = subject.id
                        }
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

    var header: some View {
        HStack(alignment: .center) {
            Text(subject.localizedName(languageCode: languageCode))
                .font(.title2)
                .foregroundColor(Colors.black)
                .multilineTextAlignment(.leading)

            
            Text(subject.progress)
                .font(.subheadline)
                .foregroundColor(Colors.black.opacity(0.5))
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
    
    private func gradeItem(lesson: Lesson) -> some View {
        
        let special: Bool = {
            let title = lesson.localizedTitle(languageCode: languageCode).lowercased()

            return title.contains("лаб")
                || title.contains("laboratory")
                || title.contains("lab")
                || title.contains("实验")
                || title.contains("рубеж")
        }()

        return VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(lesson.localizedTitle(languageCode: languageCode))
                    .fontWeight(special ? .semibold : .regular)
                    .lineLimit(nil)
                
                Spacer()

                Text(lesson.localizedStatus(languageCode: languageCode))
                    .foregroundColor(lesson.localizedStatusColor(languageCode: languageCode))
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
