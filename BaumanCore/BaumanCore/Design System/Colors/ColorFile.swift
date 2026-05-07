import SwiftUI

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")

        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0

        self.init(red: r, green: g, blue: b)
    }
}


enum Colors {
    static var MainColor: Color {
        Color("MainColor")
    }
    
    static var black: Color {
        Color("black")
    }
    
    static var white: Color {
        Color("white")
    }
    static var sistema: Color {
        Color("sistema")
    }
    
    static var systemblue: Color {
        Color("systemblue")
    }
    
    static var excellentmark: Color {
        Color("excellentmark")
    }
    
    static var badmark: Color {
        Color("badmark")
    }
    
    static var goodmark: Color {
        Color("goodmark")
    }
    
    static var LightGray: Color {
        Color("LightGray")
    }
    
    static var LightLightGray: Color {
        Color("LightLightGray")
    }
    
    static var mediummark: Color {
        Color("mediummark")
    }
    
    static var nomark: Color {
        Color("nomark")
    }
}

extension Lesson {
    func statusColor(languageCode: String) -> Color {
        let status = localizedStatus(languageCode: languageCode)
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)

        if status.contains("посещено")
            || status.contains("сдано")
            || status.contains("защищено вовремя")
            || status.contains("attended")
            || status.contains("passed")
            || status.contains("submitted")
            || status.contains("已出勤")
            || status.contains("已通过") {
            return Colors.excellentmark
        }

        if status.contains("не сдано")
            || status.contains("не посещено")
            || status.contains("absent")
            || status.contains("not attended")
            || status.contains("failed")
            || status.contains("未出勤")
            || status.contains("未通过") {
            return Colors.badmark
        }

        if status.contains("опоздан")
            || status.contains("late")
            || status.contains("迟") {
            return Colors.mediummark
        }

        return Colors.nomark
    }
}

func colorForGrade(_ grade: String) -> Color {
    switch grade {
    case "Отлично", "Зачтено":
        return Colors.excellentmark
    case "Хорошо":
        return Colors.goodmark
    case "Удов":
        return Colors.mediummark
    case "Неуд", "Не зачтено":
        return Colors.badmark
    default:
        return Colors.nomark
    }
}
