import SwiftUI

// основной каркас экрана

struct Grades: View {
    @State private var selectedTab: Tab = .current
    
    enum Tab { // вкладки
        case current
        case session
    }
    
    // данные предметов
    
    let subjects: [SubjectData] = [
        SubjectData(
            name: "Иностранный язык",
            progress: "0/100",
            lessons: [
                Lesson(title: "Семинар 1", date: "10.09.25", status: "Посещено", statusColor: Color.excellentmark),
                Lesson(title: "Рубежный контроль 1", date: "29.09.25", status: "Не проставлено", statusColor: Color.nomark),
            ]
        ),
        SubjectData(
            name: "Биомеханика",
            progress: "42/100",
            lessons: [
                Lesson(title: "Лекция 1", date: "05.09.25", status: "Посещено", statusColor: Color.excellentmark),
                Lesson(title: "Семинар 2", date: "12.09.25", status: "Работа на семинаре", statusColor: Color.excellentmark),
                Lesson(title: "Лабораторная работа 1", date: "20.09.25", status: "Не защищено", statusColor: Color.badmark)
            ]
        ),
        SubjectData(
            name: "Основы взаимодействия физических полей с биообъектами",
            progress: "30/100",
            lessons: [
                Lesson(title: "Рубежный контроль 1", date: "03.09.25", status: "Сдано", statusColor: Color.excellentmark),
                Lesson(title: "Рубежный контроль 2", date: "10.09.25", status: "Не сдано", statusColor: Color.badmark)
            ]
            
        ),
        SubjectData(
            name: "Клиническая терапия и хирургия",
            progress: "21/100",
            lessons: [
                Lesson(title: "Лекция 1", date: "13.09.25", status: "Пропущено", statusColor: Color.badmark)
            ]
        ),
        SubjectData(
            name: "Медицинские информационные системы",
            progress: "67/100",
            lessons: [
                Lesson(title: "Лекция 1", date: "05.09.25", status: "Посещено", statusColor: Color.excellentmark),
            ]
        ),
        SubjectData(
            name: "Метрология, стандартизация и технические измерения",
            progress: "0/100",
            lessons: [
                Lesson(title: "Семинар 1", date: "10.09.25", status: "Посещено", statusColor: Color.excellentmark),
                Lesson(title: "Лекция 1", date: "13.09.25", status: "Пропущено", statusColor: Color.badmark),
                Lesson(title: "Лабораторная работа 1", date: "21.09.25", status: "Защищено вовремя", statusColor: Color.excellentmark),
                Lesson(title: "Рубежный контроль 1", date: "29.09.25", status: "Не проставлено", statusColor: Color.nomark),
                Lesson(title: "Лабораторная работа 2", date: "01.10.25", status: "Защищено с опозданием", statusColor: Color.mediummark)
            ]
        ),
        SubjectData(
            name: "Разработка программных Интернет-приложений",
            progress: "0/100",
            lessons: [
                Lesson(title: "Рубежный контроль 1", date: "03.09.25", status: "Сдано", statusColor: Color.excellentmark),
                Lesson(title: "Рубежный контроль 2", date: "10.09.25", status: "Не сдано", statusColor: Color.badmark)
            ]
        ),
        SubjectData(
            name: "Философия",
            progress: "60/100",
            lessons: [
                Lesson(title: "Лекция 1", date: "05.09.25", status: "Посещено", statusColor: Color.excellentmark),
                Lesson(title: "Семинар 2", date: "12.09.25", status: "Работа на семинаре", statusColor: Color.excellentmark),
            ]
        ),
        SubjectData(
            name: "Элективный курс по физической культуре и спорту",
            progress: "49/100",
            lessons: [
                Lesson(title: "Занятие 1", date: "03.09.25", status: "Посещено", statusColor: Color.excellentmark),
                Lesson(title: "Занятие 2", date: "10.09.25", status: "Не посещено", statusColor: Color.badmark)
            ]
            
        ),
        SubjectData(
            name: "Электроника и микропроцессорная техника",
            progress: "29/100",
            lessons: [
                Lesson(title: "Семинар 1", date: "10.09.25", status: "Посещено", statusColor: Color.excellentmark),
                Lesson(title: "Лекция 1", date: "13.09.25", status: "Пропущено", statusColor: Color.badmark),
                Lesson(title: "Лабораторная работа 1", date: "21.09.25", status: "Защищено вовремя", statusColor: Color.excellentmark),
                Lesson(title: "Рубежный контроль 1", date: "29.09.25", status: "Не проставлено", statusColor: Color.nomark),
                Lesson(title: "Лабораторная работа 2", date: "01.10.25", status: "Защищено с опозданием", statusColor: Color.mediummark)
            ]
        )
    ]
    
    // данные семестров
    
    struct SessionTabView: View {
        @State private var expandedSemester: Int? = nil

        var body: some View {
            VStack(spacing: 16) {

                SemesterSection(
                    title: "1 семестр",
                    isExpanded: expandedSemester == 1,
                    onToggle: { toggle(1) },
                    subjects: [
                        ("Основы взаимодейтсвия физических полей с биообъектами", "Зачтено", Color.excellentmark),
                        ("Иностранный язык", "Отлично", Color.excellentmark),
                        ("Разработка программных Интернет-приложений", "Хорошо", Color.goodmark),
                        ("Метрология, стандартизация и технические измерения", "Удовлетворительно", Color.mediummark),
                        ("Биомеханика", "Не проставлено", Color.nomark),
                        ("Элективный курс по физической культуре и спорту", "Неудовлетворительно", Color.badmark),
                        ("Клиническая терапия и хирургия", "Зачтено", Color.excellentmark),
                        ("Медицинские информационные системы", "Неудовлетворительно", Color.badmark),
                        ("Философия", "Хорошо", Color.goodmark),
                        ("Электроника и микропроцессорная техника", "Удовлетворительно", Color.mediummark)
                        
                    ]
                )

                SemesterSection(
                    title: "2 семестр",
                    isExpanded: expandedSemester == 2,
                    onToggle: { toggle(2) },
                    subjects: []
                )

                SemesterSection(
                    title: "3 семестр",
                    isExpanded: expandedSemester == 3,
                    onToggle: { toggle(3) },
                    subjects: []
                )

                SemesterSection(
                    title: "4 семестр",
                    isExpanded: expandedSemester == 4,
                    onToggle: { toggle(4) },
                    subjects: []
                )
            }
            .padding(.bottom, 30)
        }

        private func toggle(_ id: Int) {
            withAnimation(.easeInOut(duration: 0.5)) {
                expandedSemester = expandedSemester == id ? nil : id
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    // контент (что отобразить в скролле)
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(spacing: 12) {
                    if selectedTab == .current {
                        ForEach(subjects, id: \.name) { subject in
                            SubjectRowView(subject: subject) // текущие предметы
                        }
                    } else {
                        SessionTabView() // сессия
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
            
            if #available(iOS 26.0, *) { // версия iOS
                GradesHatView(selectedTab: $selectedTab)
                    .glassEffect(.clear, in: .rect(cornerRadius: 0, style: .continuous))
                    .clipShape(HorizontalInsetShape(insetX: 17))
                    .zIndex(1)
            } else {
                GradesHatView(selectedTab: $selectedTab)
                    .background(Color.white)
                    .clipShape(HorizontalInsetShape(insetX: 17))
                    .zIndex(1)
            }
        }
    }
}
