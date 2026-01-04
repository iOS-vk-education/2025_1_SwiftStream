import SwiftUI

struct Grades: View {
    @State private var selectedTab: Tab = .current

    enum Tab {
        case current
        case session
    }

    @State private var subjects: [SubjectData] = []
    @State private var semesters: [Semester] = []

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(spacing: 12) {
                    if selectedTab == .current {
                        ForEach(subjects, id: \.id) { subject in
                            SubjectRowView(subject: subject)
                        }
                    } else {
                        SessionTabView(semesters: semesters)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 150)
                .padding(.bottom, 30)
            }

            Rectangle()
                .fill(Color.white)
                .frame(height: 120)
                .ignoresSafeArea(edges: .top)

            
            /*GradesHatView(selectedTab: $selectedTab)
                    .glassEffect(.clear, in: .rect(cornerRadius: 0, style: .continuous))
                    .clipShape(HorizontalInsetShape(insetX: 16))
                    .zIndex(1)  */
         
               GradesHatView(selectedTab: $selectedTab)
                    .background(Color.white)
                    .clipShape(HorizontalInsetShape(insetX: 16))
                    .zIndex(1)
            
        }
        
        .onAppear {
            FirebaseService().fetchStudent { student in
                if let student = student {
                    self.subjects = student.subjects
                    self.semesters = student.semesters
                } else {
                    self.subjects = []
                    self.semesters = []
                }
            }
        }
    }
}



struct SessionTabView: View {
    var semesters: [Semester]
    @State private var expandedSemester: String? = nil

    var body: some View {
        VStack(spacing: 16) {
            ForEach(semesters, id: \.id) { semester in
                SemesterSection(
                    title: semester.title,
                    isExpanded: expandedSemester == semester.id,
                    onToggle: { toggle(semester.id) },
                    subjects: semester.subjects.map { ($0.name, $0.grade, colorForGrade($0.grade)) }
                )
            }
        }
        .padding(.bottom, 30)
    }

    private func toggle(_ id: String) {
        withAnimation(.easeInOut(duration: 0.5)) {
            expandedSemester = expandedSemester == id ? nil : id
        }
    }
}
