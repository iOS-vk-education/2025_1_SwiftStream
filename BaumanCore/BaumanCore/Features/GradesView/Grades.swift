//
//  Grades.swift
//  BaumanCore
//
//  Created by Иван Агошков on 26.03.2026.
//


import SwiftUI
import Combine
import FirebaseAuth

struct Grades: View {
    @State private var selectedTab: Tab = .current
    @State private var expandedSubjectId: String? = nil

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
                                expandedSubjectId: $expandedSubjectId
                            )
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
        
        // Подписываемся на обновления ViewModel
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