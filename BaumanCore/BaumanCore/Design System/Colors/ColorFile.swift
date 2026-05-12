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

        if status == "посещено"
            || status == "attended"
            || status == "已出勤"
            || status == "защищено вовремя"
            || status == "completed on time"
            || status == "按时答辩"
            || status == "сдано"
            || status == "passed"
            || status == "通过" {

            return Colors.excellentmark
        }

        if status == "не посещено"
            || status == "absent"
            || status == "缺勤"
            || status == "не защищено"
            || status == "not completed"
            || status == "未完成"
            || status == "не сдано"
            || status == "failed"
            || status == "未提交" {

            return Colors.badmark
        }

        if status == "защищено с опозданием"
            || status == "completed late"
            || status == "延期答辩" {

            return Colors.mediummark
        }

        if status == "не проставлено"
            || status == "not marked"
            || status == "未评分" {

            return Colors.nomark
        }

        return Colors.nomark
    }
}

func colorForGrade(_ grade: String) -> Color {
    switch grade {
    case "Отлично", "Зачтено", "Excellent", "Passed", "优秀", "通过":
        return Colors.excellentmark
    case "Хорошо", "Good", "良好":
        return Colors.goodmark
    case "Удов", "Satisfactory", "及格":
        return Colors.mediummark
    case "Неуд", "Не зачтено", "Bad", "Failed", "不及格", "未通过":
        return Colors.badmark
    default:
        return Colors.nomark
    }
}
