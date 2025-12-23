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

enum AppColor {
    static let black = Color(hex: "#000000")
    static let darkGrey = Color(hex: "#4B4A4A")
    static let lightGrey = Color(hex: "#6A6A6A")
    static let lightlightGrey = Color(hex: "#C4C4C4")
    static let white = Color(hex: "#FFFFFF")
    
    
    static let mainColor = Color(hex: "#2932D9")
}



enum MarksColor {
    static let excellentmark = Color(hex: "#388E3C")
    static let goodmark = Color(hex: "#81C784")
    static let mediummark = Color(hex: "#DAA520")
    static let badmark = Color(hex: "#E57373")
    static let nomark = Color(hex: "#808080")
}


// оценки уроков
extension Lesson {
    var statusColor: Color {
        switch status {
        case "Посещено", "Сдано", "Отлично": return MarksColor.excellentmark
        case "Не сдано", "Не посещено", "Неуд": return MarksColor.badmark
        case "Удов", "Защищено с опозданием": return MarksColor.mediummark
        case "Хорошо": return MarksColor.goodmark
        default: return MarksColor.nomark
        }
    }
}


// оценки дисциплин семестра
func colorForGrade(_ grade: String) -> Color {
    switch grade {
    case "Отлично":
        return MarksColor.excellentmark
    case "Хорошо":
        return MarksColor.goodmark
    case "Удов":
        return MarksColor.mediummark
    case "Неуд":
        return MarksColor.badmark
    default:
        return MarksColor.nomark
    }
}
