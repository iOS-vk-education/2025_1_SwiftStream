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
        Color("MainColor") // имя цвета в Assets
    }
    
    static var black: Color {
        Color("black")
    }
    
    static var white: Color {
        Color("white")
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

// оценки уроков
extension Lesson {
    var statusColor: Color {
        switch status {
        case "Посещено", "Сдано", "Отлично": return Colors.excellentmark
        case "Не сдано", "Не посещено", "Неуд": return Colors.badmark
        case "Удов", "Защищено с опозданием": return Colors.mediummark
        case "Хорошо": return Colors.goodmark
        default: return Colors.nomark
        }
    }
}


// оценки дисциплин семестра
func colorForGrade(_ grade: String) -> Color {
    switch grade {
    case "Отлично":
        return Colors.excellentmark
    case "Хорошо":
        return Colors.goodmark
    case "Удов":
        return Colors.mediummark
    case "Неуд":
        return Colors.badmark
    default:
        return Colors.nomark
    }
}
