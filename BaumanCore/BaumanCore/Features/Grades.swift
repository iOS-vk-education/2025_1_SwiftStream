// Created by Иван Агошков

import SwiftUI

struct GradesView: View {
    @State private var selectedTab: Tab = .current
    
    enum Tab {
        case current
        case session
    }
    
    let subjects: [SubjectData] = [

        SubjectData(
            name: "Иностранный язык",
            progress: "0/100",
            lessons: [
                Lesson(title: "Семинар 1", date: "10.09.25", status: "Посещено", statusColor: .green),
                Lesson(title: "Лекция 1", date: "13.09.25", status: "Пропущено", statusColor: .red),
                Lesson(title: "Лабораторная работа 1", date: "21.09.25", status: "Защищено вовремя", statusColor: .green),
                Lesson(title: "Лабораторная работа 2", date: "01.10.25", status: "Защищено с опозданием", statusColor: .orange)
            ]
        ),

        SubjectData(
            name: "Биомеханика",
            progress: "42/100",
            lessons: [
                Lesson(title: "Лекция 1", date: "05.09.25", status: "Посещено", statusColor: .green),
                Lesson(title: "Лекция 2", date: "12.09.25", status: "Посещено", statusColor: .green),
                Lesson(title: "Лабораторная 1", date: "20.09.25", status: "Сдано", statusColor: .green)
            ]
        ),

        SubjectData(
            name: "Основы взаимодействия физических полей с биообъектами",
            progress: "30/100",
            lessons: [
                Lesson(title: "Семинар 1", date: "03.09.25", status: "Посещено", statusColor: .green),
                Lesson(title: "Семинар 2", date: "10.09.25", status: "Посещено", statusColor: .green),
                Lesson(title: "Эссе", date: "21.09.25", status: "Не сдано", statusColor: .red)
            ]
        )

    ]

struct GradesHatView: View {
    @Binding var selectedTab: GradesView.Tab
    
    var body: some View {
        VStack() {
            VStack(spacing: 24) {
                // Название
                HStack {
                    Text("Успеваемость")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.black)
                    Spacer()
                }
                // Вкладки
                HStack(spacing: 24) {
                    gradesTabButton(
                        title: "Текущая",
                        isActive: selectedTab == .current
                    ) {
                        selectedTab = .current
                    }
                    
                    gradesTabButton(
                        title: "Сессия",
                        isActive: selectedTab == .session
                    ) {
                        selectedTab = .session
                    }
                //    .padding(.bottom)
                    
                }
                
                
            }
            
            .padding()
            .frame(maxWidth: .infinity)
            
            
          
            
            
        }
        

        
    }
    @ViewBuilder
    private func gradesTabButton(title: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(isActive ? .white : .black)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(
                    Capsule()
                        .fill(isActive ? Color.gradesBlue : .white)
                        .overlay(
                            Capsule()
                                .stroke(Color.black.opacity(isActive ? 0 : 0.5), lineWidth: 1)
                        )
                )
        }
    }
}


    struct HorizontalInsetShape: Shape {
        var insetX: CGFloat
        var cornerRadius: CGFloat = 30

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


    
    var body: some View {
        ZStack(alignment: .top) {

            // ScrollView с контентом
            ScrollView {
                VStack(spacing: 12) {
                    if selectedTab == .current {
                        ForEach(subjects, id: \.name) { subject in
                            SubjectRowView(subject: subject)
                        }
                    } else {
                        SessionTabView()
                    }
                }
                .padding(.horizontal)
                .padding(.top, 150) // <- отступ под шапку
                .padding(.bottom, 30)
            }
            
            VStack {
                Rectangle()
                    .fill(Color.white)
                    .frame(height: 120)
                    .ignoresSafeArea(edges: .top)
                
                
            }

            // Шапка с Liquid Glass поверх ScrollView
            GradesHatView(selectedTab: $selectedTab)
                .glassEffect(.clear, in: .rect(cornerRadius: 0, style: .continuous))
                
            
           /*     .background(
                    Rectangle()
                            // правильный материал
                        
                        .mask(
                            VStack(spacing: 0) {
                                Rectangle()
                                    .fill(Color.white)// нижняя часть — видимая
                                Rectangle()
                                    
                                    .frame(height: 80)  // верхняя маска вырезает преломление
                                    .opacity(0)
                                    
                                    
                            }
                        )
                ) */
                .clipShape(HorizontalInsetShape(insetX: 16))
                
            
                .zIndex(1) // обязательно поверх ScrollView

            
        }
       
    }


    
    
    
    
    
    
    
    // Кнопки вкладок
    @ViewBuilder
    private func gradesTabButton(title: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(isActive ? .white : .black)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                
                .background(
                    Capsule()
                        .fill(isActive ? Color.gradesBlue : .white)
                        .overlay(
                            Capsule()
                                .stroke(Color.black.opacity(isActive ? 0 : 0.5), lineWidth: 1)
                        )
                )
        
        }
    }
}








// Предметы с выпадением
struct SubjectRowView: View {
    let subject: SubjectData
    @State private var isExpanded = false

    var body: some View {
        VStack(spacing: 0) {
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.25)) {
                    isExpanded.toggle()
                }
            }) {
                HStack(alignment: .center) {

                    Text(subject.name)
                        .font(.title2)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(subject.progress)
                        .font(.subheadline)
                        .foregroundColor(.black.opacity(0.5))
                        .padding(.leading, 4)
                        .padding(.top, 4)

                    Spacer(minLength: 30)

                    Image(systemName: "chevron.right")
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                        .foregroundColor(.gray)
                        .padding(.top, 2)
                }
                .padding(.vertical, 8)
            }

            // Выпадающий блок
            if isExpanded {
                VStack(spacing: 12) {
                    ForEach(subject.lessons) { lesson in
                        gradeItem(lesson: lesson)
                    }
                }
                .padding(.vertical, 8)
               
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        
        .clipped()
    }

    // -----------------------
    // Карточка занятия
    // -----------------------
    @ViewBuilder
    private func gradeItem(lesson: Lesson) -> some View {
        VStack(alignment: .leading, spacing: 6) {

            HStack {
                Text(lesson.title)
                    .font(.body)

                Spacer()

                Text(lesson.status)
                    .font(.subheadline)
                    .foregroundColor(lesson.statusColor)
            }

            Text(lesson.date)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(.ultraThickMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}




// Сессия
struct SemesterSection: View {
    let title: String
    let isExpanded: Bool
    let onToggle: () -> Void
    let subjects: [(String, String, Color)]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            // Заголовок семестра
            Button(action: onToggle) {
                HStack {
                    Text(title)
                        .font(.title2)
                        .foregroundColor(.black)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                        .foregroundColor(.gray)
                        .padding(.top, 2)
                        
                }
                .padding(.vertical, 8)
            }

            // Список предметов
            if isExpanded {
                VStack(alignment: .leading, spacing: 10) {

                    ForEach(subjects, id: \.0) { subject in
                        HStack(alignment: .center) {

                            // Название предмета
                            Text(subject.0)
                                .font(.body)
                                .foregroundColor(.black)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Spacer(minLength: 16)

                            // Оценка
                            Text(subject.1)
                                .font(.subheadline)
                                .foregroundColor(subject.2)
                                .multilineTextAlignment(.trailing)
                        }
                    }

                }
                .padding(.leading, 4)
                .padding(.top, 4)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
                
        }
        .clipped()
    }
}



struct SessionTabView: View {
   @State private var expandedSemester: Int? = nil
   
   var body: some View {
       VStack(spacing: 16) {

           // 1 семестр
           SemesterSection(
               title: "1 семестр",
               isExpanded: expandedSemester == 1,
               onToggle: { toggle(1) },
               subjects: [
                   ("Основы взаимодейтвия физических полей с биообъектами", "Зачтено", Color.green),
                   ("История", "Отлично", Color.green),
                   ("Разработка программных Интернет-приложений", "Удовлетворительно", Color.yellow),
                   ("Медицинские информационные системы", "Неудовлетворительно", Color.red),
                   ("Математика", "Не зачтено", Color.red)
               ]
           )

           // 2 семестр
           SemesterSection(
               title: "2 семестр",
               isExpanded: expandedSemester == 2,
               onToggle: { toggle(2) },
               subjects: []
           )

           // 3 семестр
           SemesterSection(
               title: "3 семестр",
               isExpanded: expandedSemester == 3,
               onToggle: { toggle(3) },
               subjects: []
           )

           // 4 семестр
           SemesterSection(
               title: "4 семестр",
               isExpanded: expandedSemester == 4,
               onToggle: { toggle(4) },
               subjects: []
           )
       }
       .padding(.bottom, 30)
   }
   
   // Открытие/закрытие
   private func toggle(_ id: Int) {
       withAnimation(.easeInOut(duration: 0.25)) {
           expandedSemester = expandedSemester == id ? nil : id
       }
   }
}




// поправить анимацию развертывания
// убрать перенос названия предмета послогово (иногда возникает)
// поправить отступ слева у предметов в сессии
