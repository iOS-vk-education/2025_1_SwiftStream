import Foundation
import SwiftUI

final class ScheduleDateManager: ObservableObject {
    @Published var currentWeek: Int = 1
    @Published var currentDayIndex: Int = 1
    @Published var isEvenWeek: Bool = false
    @Published var currentWeekStartDate: Date = Date()
    @Published var animateDayButtons: Bool = false // Новое свойство для анимации
    
    init() {
        updateRealDate()
        calculateWeekStartDate()
    }
    
    private func calculateWeekStartDate() {
        let calendar = Calendar.current
        let today = Date()
        
        guard let monday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)) else {
            return
        }
        
        let weeksFromStart = currentWeek - 1
        if let adjustedMonday = calendar.date(byAdding: .weekOfYear, value: weeksFromStart, to: monday) {
            currentWeekStartDate = adjustedMonday
        }
    }
    
    func getDateForDay(dayIndex: Int) -> Date? {
        let calendar = Calendar.current
        let dayOffset = dayIndex - 1
        
        return calendar.date(byAdding: .day, value: dayOffset, to: currentWeekStartDate)
    }
    
    func getDayNumberForDay(dayIndex: Int) -> String {
        guard let date = getDateForDay(dayIndex: dayIndex) else { return "" }
        let calendar = Calendar.current
        let dayNumber = calendar.component(.day, from: date)
        return "\(dayNumber)"
    }
    
    func updateRealDate() {
        let calendar = Calendar.current
        let today = Date()
        
        let weekday = calendar.component(.weekday, from: today)
        currentDayIndex = weekday == 1 ? 6 : weekday - 1
        
        let year = calendar.component(.year, from: today)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let firstSeptember = formatter.date(from: "01.09.\(year)")!
        
        if let weeks = calendar.dateComponents([.weekOfYear], from: firstSeptember, to: today).weekOfYear {
            currentWeek = max(1, weeks + 1)
        }
        
        isEvenWeek = currentWeek % 2 == 0
        calculateWeekStartDate()
    }
    
    
    func nextWeek() {
            withAnimation(.easeInOut(duration: 0.3)) {
                animateDayButtons = true
            }
            
            currentWeek += 1
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
