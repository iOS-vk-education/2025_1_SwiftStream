//import Foundation
//import SwiftUI
//
//enum LessonType {
//    case lecture
//    case seminar
//    case lab
//
//    var color: Color {
//        switch self {
//        case .lecture:
//            return Color.blue.opacity(0.4)
//        case .seminar:
//            return Color.mint.opacity(0.4)
//        case .lab:
//            return Color.purple.opacity(0.4)
//        }
//    }
//
//    var textColor: Color {
//        switch self {
//        case .lecture:
//            return .blue
//        case .seminar:
//            return .mint
//        case .lab:
//            return .purple
//        }
//    }
//
//    var title: LocalizedStringKey {
//        switch self {
//        case .lecture:
//            return Translation.LessonType.lecture
//        case .seminar:
//            return Translation.LessonType.seminar
//        case .lab:
//            return Translation.LessonType.lab
//        }
//    }
//}
//
//struct LessonCardView: View {
//    let type: LessonType
//    let timeStart: String
//    let timeEnd: String
//    let subject: String
//    let teacher: String
//    let classroom: String
//    var onClassroomTap: ((String) -> Void)? = nil
//
//    var body: some View {
//        VStack(spacing: 0) {
//            Text(type.title)
//                .font(.system(size: 14, weight: .bold))
//                .foregroundColor(.white)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .padding(.vertical, 3)
//                .padding(.leading, 12)
//                .background(type.color)
//
//            HStack(alignment: .top, spacing: 12) {
//                VStack(alignment: .leading) {
//                    Text(timeStart)
//                        .font(.system(size: 17, weight: .bold))
//
//                    Text(timeEnd)
//                        .font(.system(size: 14))
//                        .foregroundColor(.gray)
//                }
//
//                VStack(alignment: .leading, spacing: 4) {
//                    Text(subject)
//                        .font(.system(size: 16, weight: .semibold))
//
//                    Text(teacher)
//                        .font(.system(size: 14))
//                        .foregroundColor(.gray)
//
//                    Button(action: {
//                        onClassroomTap?(classroom)
//                    }) {
//                        Text("ауд. \(classroom)")
//                            .font(.system(size: 14, weight: .medium))
//                            .foregroundColor(Colors.MainColor)
//                            .underline()
//                    }
//                }
//            }
//            .padding(12)
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .background(Colors.white)
//        }
//        .cornerRadius(12)
//        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 3)
//        .padding(.horizontal)
//    }
//}
import Foundation
import SwiftUI

enum LessonType: String {
    case lecture = "Лекция"
    case seminar = "Семинар"
    case lab = "Лабораторная"

    var color: Color {
        switch self {
        case .lecture: return Color.blue.opacity(0.4)
        case .seminar: return Color.mint.opacity(0.4)
        case .lab:     return Color.purple.opacity(0.4)
        }
    }
}

struct LessonCardView: View {
    let type: LessonType
    let timeStart: String
    let timeEnd: String
    let subject: String
    let teacher: String
    let classroom: String

    var body: some View {
        VStack(spacing: 0) {
            Text(type.rawValue)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 3)
                .padding(.leading, 12)
                .background(type.color)

            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(timeStart)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)

                    Text(timeEnd)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                .frame(width: 55, alignment: .leading)

                VStack(alignment: .leading, spacing: 4) {
                    Text(subject)
                        .font(.system(size: 16, weight: .semibold))
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(nil)
                        .multilineTextAlignment(.leading)

                    Text(teacher)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .fixedSize(horizontal: false, vertical: true)

                    let trimmedClassroom = classroom.trimmingCharacters(in: .whitespacesAndNewlines)

                    Text(trimmedClassroom.lowercased() == "спортивный зал" ? trimmedClassroom : "ауд. \(trimmedClassroom)")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Colors.white)
        }
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 3)
        .padding(.horizontal)
    }
}
