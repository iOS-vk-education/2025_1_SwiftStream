import Foundation
import SwiftUI

final class ScheduleDateManager: ObservableObject {
    @Published var currentWeek: Int = 1
    @Published var currentDayIndex: Int = 1
    @Published var isEvenWeek: Bool = false
    @Published var currentWeekStartDate: Date = Date()
    @Published var animateDayButtons: Bool = false
    
    private let calendar = Calendar.current
    
    init() {
        updateRealDate()
        calculateWeekStartDate()
    }
    
    private func calculateWeekStartDate() {
        let calendar = Calendar.current
        let today = Date()

        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)
        guard let monday = calendar.date(from: components) else {
            return
        }

        let weeksFromCurrent = currentWeek - getCurrentAcademicWeek()
        if let adjustedMonday = calendar.date(byAdding: .weekOfYear, value: weeksFromCurrent, to: monday) {
            currentWeekStartDate = adjustedMonday
        }
    }
    
    private func startOfWeek(for date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return calendar.date(from: components)!
    }
    
    
    private func getCurrentAcademicWeek() -> Int {
        let today = Date()
        let calendar = Calendar.current

        // Определяем дату 1 сентября
        let year = calendar.component(.year, from: today)
        var septemberComponents = DateComponents()
        septemberComponents.year = year
        septemberComponents.month = 9
        septemberComponents.day = 1

        var firstSeptember = calendar.date(from: septemberComponents)!
        if today < firstSeptember {
            septemberComponents.year = year - 1
            firstSeptember = calendar.date(from: septemberComponents)!
        }

        // Получаем понедельник недели, в которую попадает 1 сентября
        let startOfAcademicWeek = startOfWeek(for: firstSeptember)

        // Получаем понедельник недели, в которую попадает сегодня
        let startOfCurrentWeek = startOfWeek(for: today)

        // Считаем разницу в днях между этими двумя понедельниками
        let daysBetween = calendar.dateComponents([.day], from: startOfAcademicWeek, to: startOfCurrentWeek).day ?? 0

        // Переводим разницу в неделях
        let weekDifference = daysBetween / 7

        return max(1, weekDifference + 1)
    }
    
    func getDateForDay(dayIndex: Int) -> Date? {
        let dayOffset = dayIndex // ПН = 0, ВТ = 1 и т.д.
        return calendar.date(byAdding: .day, value: dayOffset, to: currentWeekStartDate)
    }
    
    func getDayNumberForDay(dayIndex: Int) -> String {
        guard let date = getDateForDay(dayIndex: dayIndex) else { return "" }
        let dayNumber = calendar.component(.day, from: date)
        return "\(dayNumber)"
    }
    
    func updateRealDate() {
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)

        // Оставляем логику как раньше: Пн = 1, ..., Сб = 6, Вс = 0 → делаем 6 (сб)
        currentDayIndex = weekday == 1 ? 0 : weekday - 1 // Вс = 0, Пн = 1, ..., Сб = 6

        currentWeek = getCurrentAcademicWeek()
        if weekday == 1 { // если сегодня воскресенье
            currentWeek -= 1 // отображаем предыдущую неделю
        }
        isEvenWeek = currentWeek % 2 == 0
        calculateWeekStartDate()
    }
    
    func nextWeek() {
        withAnimation(.easeInOut(duration: 0.3)) {
            animateDayButtons = true
        }
        
        
        if currentWeek < 18 {
            currentWeek += 1
        }
        isEvenWeek = currentWeek % 2 == 0
        calculateWeekStartDate()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeInOut(duration: 0.1)) {
                self.animateDayButtons = false
            }
        }
    }
    
    func prevWeek() {
        withAnimation(.easeInOut(duration: 0.3)) {
            animateDayButtons = true
        }
        
        currentWeek -= 1
        if currentWeek < 1 { currentWeek = 1 }
        isEvenWeek = currentWeek % 2 == 0
        calculateWeekStartDate()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeInOut(duration: 0.1)) {
                self.animateDayButtons = false
            }
        }
    }
    
    var weekTitle: String {
        "\(currentWeek) неделя, \(isEvenWeek ? "знаменатель" : "числитель")"
    }
}
