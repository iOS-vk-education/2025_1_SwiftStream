import Foundation
import SwiftUI

enum LessonType {
    case lecture
    case seminar
    case lab

    var color: Color {
        switch self {
        case .lecture:
            return Color.blue.opacity(0.4)
        case .seminar:
            return Color.mint.opacity(0.4)
        case .lab:
            return Color.purple.opacity(0.4)
        }
    }
}

struct LessonCardView: View {
    let type: LessonType
    let typeTitle: String
    let timeStart: String
    let timeEnd: String
    let subject: String
    let teacher: String
    let classroom: String
    let languageCode: String

    var onClassroomTap: ((String) -> Void)? = nil

    var body: some View {
        VStack(spacing: 0) {

            Text(typeTitle)
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
                        .multilineTextAlignment(.leading)

                    Text(teacher)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)

                    HStack(spacing: 0) {

                        // префикс НЕ кликабельный
                        if !prefix.isEmpty {
                            Text(prefix)
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }

                        // кликабельна ТОЛЬКО аудитория
                        if isClickableClassroom {

                            Button(action: {
                                onClassroomTap?(classroom)
                            }) {
                                Text(classroomDisplayText)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Colors.MainColor)
                                    .underline()
                            }
                            .buttonStyle(.plain)

                        } else {

                            Text(classroomDisplayText)
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                    }
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

    // MARK: - Helpers

    private var trimmedClassroom: String {
        classroom.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var lowercased: String {
        trimmedClassroom.lowercased()
    }

    private var isSportsHall: Bool {
        lowercased.contains("спорт") ||
        lowercased.contains("sports hall") ||
        lowercased.contains("体育馆")
    }
    
    private var isClickableClassroom: Bool {

        if isSportsHall {
            return false
        }

        let room = lowercased

        return !room.contains("к")
            && !room.contains("х")
            && !room.contains("л")
    }

    private var prefix: String {
        if isSportsHall {
            return ""
        }

        if languageCode.hasPrefix("zh") {
            return "教室 "
        }

        if languageCode.hasPrefix("en") {
            return "room "
        }

        return "ауд. "
    }

    private var classroomDisplayText: String {
        trimmedClassroom
    }
}
