// Created by Иван Агошков

import SwiftUI

struct Grades: View {
    @State private var selectedTab: Tab = .current
    
    enum Tab {
        case current
        case session
    }
    
    var body: some View {
        VStack(spacing: 0) {

            // Шапка
            HStack {
                Text("Успеваемость")
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal, 16)
                    .padding(.top, 56)
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
            }
            .padding(.top, 15)
            .padding(.horizontal)
            
            // Предметы
            ScrollView {
                VStack(spacing: 12) {
                    if selectedTab == .current {
                        SubjectRowView(subjectName: "Биомеханика", progress: "21/100")
                        SubjectRowView(subjectName: "Иностранный язык", progress: "50/100")
                        SubjectRowView(subjectName: "Клиническая терапия и хирургия", progress: "42/100")
                        SubjectRowView(subjectName: "Медицинские информационные системы", progress: "0/100")
                        SubjectRowView(subjectName: "Метрология, стандартизация и технические измерения", progress: "0/100")
                        SubjectRowView(subjectName: "Основы взаимодействия физических полей биообъектами", progress: "14/100")
                        SubjectRowView(subjectName: "Разработка программных Интернет-приложений", progress: "10/100")
                        SubjectRowView(subjectName: "Философия", progress: "60/100")
                        SubjectRowView(subjectName: "Элективный курс по физической культуре и спорту", progress: "36/100")
                        SubjectRowView(subjectName: "Электроника", progress: "0/100")
                    } else {
                        SessionTabView()
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                .padding(.bottom, 30)
            }
            

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
                        .fill(isActive ? Color(hex: "2932D9") : .white)
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
    let subjectName: String
    let progress: String
    @State private var isExpanded = false
    
    var body: some View {
        VStack(spacing: 0) {
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.25)) {
                    isExpanded.toggle()
                }
            }) {
                HStack(alignment: .center) {
                    // Название предмета
                    Text(subjectName)
                        .font(.title2)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                    

                    // Прогресс
                    Text(progress)
                        .font(.subheadline)
                        .foregroundColor(.black.opacity(0.5))
                        .padding(.leading, 4)
                        .padding(.top, 4)

                    Spacer(minLength: 30)
                    
                    // Стрелка
                    Image(systemName: "chevron.right")
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                        .foregroundColor(.gray)
                        .animation(.easeInOut(duration: 0.25), value: isExpanded)
                }
                .padding(.vertical, 8)
            }
            
            // Выпадение
            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Семинар 1:")
                    Text("Лабораторная:")
                    Text("Контрольная:")
                }
                .padding(.leading)
                .padding(.bottom, 8)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
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


struct Grades_Previews: PreviewProvider {
    static var previews: some View {
        BottomBarView(selectedTab: 3)
    }
}



// поправить анимацию развертывания
// убрать перенос названия предмета послогово (иногда возникает)
// поправить отступ слева у предметов в сессии
