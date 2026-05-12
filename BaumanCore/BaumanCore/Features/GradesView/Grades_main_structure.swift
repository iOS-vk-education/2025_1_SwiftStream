import SwiftUI
import Combine
import FirebaseAuth

struct Grades: View {
    @State private var selectedTab: Tab = .current
    @State private var expandedSubjectId: String? = nil
    
    @AppStorage("userSelectedLanguage") private var selectedLanguageRawValue = 0

    private var currentLanguageCode: String {
        switch selectedLanguageRawValue {
        case 1:
            return "en"
        case 2:
            return "zh"
        default:
            return "ru"
        }
    }

    enum Tab {
        case current
        case session
    }

    @State private var subjects: [SubjectData] = []
    @State private var semesters: [Semester] = []

    @StateObject private var studentVM = StudentViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(spacing: 12) {
                    if selectedTab == .current {
                        ForEach(subjects, id: \.id) { subject in
                            SubjectRowView(
                                subject: subject,
                                expandedSubjectId: $expandedSubjectId,
                                languageCode: currentLanguageCode
                            )
                        }
                    } else {
                        SessionTabView(
                            semesters: semesters,
                            languageCode: currentLanguageCode
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.top, 150)
                .padding(.bottom, 30)
            }
            
            Rectangle()
                .fill(Colors.sistema)
                .frame(height: 120)
                .ignoresSafeArea(edges: .top)
            
            GradesHatView(selectedTab: $selectedTab)
                .background(Colors.sistema)
                .clipShape(HorizontalInsetShape(insetX: 16))
                .zIndex(1)
        }
        .onAppear {
            studentVM.fetchStudent()
        }
        .onChange(of: selectedTab) { _ in
            expandedSubjectId = nil
        }
        
        .onReceive(studentVM.$subjects) { subjects in
            self.subjects = subjects
        }
        .onReceive(studentVM.$semesters) { semesters in
            self.semesters = semesters
        }
    }
}

struct SessionTabView: View {
    var semesters: [Semester]
    let languageCode: String

    @State private var expandedSemester: String? = nil

    var body: some View {
        VStack(spacing: 12) {
            ForEach(semesters, id: \.id) { semester in
                SemesterSection(
                    title: semester.localizedTitle(languageCode: languageCode),
                    isExpanded: expandedSemester == semester.id,
                    onToggle: { toggle(semester.id) },
                    subjects: semester.subjects.map {
                        let grade = $0.localizedGrade(languageCode: languageCode)

                        return (
                            $0.localizedName(languageCode: languageCode),
                            grade,
                            colorForGrade(grade)
                        )
                    }
                )
            }
        }
        .padding(.top, -0.5)
        .padding(.bottom, 30)
    }

    private func toggle(_ id: String) {
        withAnimation(.easeInOut(duration: 0.5)) {
            expandedSemester = expandedSemester == id ? nil : id
        }
    }
}
