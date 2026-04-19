import Foundation
import SwiftUI

final class ScheduleDateManager: ObservableObject {
    @Published var currentWeek: Int = 1
    @Published var currentDayIndex: Int = 1   // Пн = 1 ... Сб = 6, Вс = 7
    @Published var isEvenWeek: Bool = false
    @Published var currentWeekStartDate: Date = Date()
    @Published var animateDayButtons: Bool = false

    private let calendar = Calendar.current

    init() {
        updateRealDate()
    }

    private func startOfWeek(for date: Date) -> Date {
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return calendar.date(from: components)!
    }

    private func getCurrentAcademicWeek() -> Int {
        let today = Date()

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

        let startOfAcademicWeek = startOfWeek(for: firstSeptember)
        let startOfCurrentWeek = startOfWeek(for: today)

        let daysBetween = calendar.dateComponents([.day], from: startOfAcademicWeek, to: startOfCurrentWeek).day ?? 0
        let weekDifference = daysBetween / 7

        return max(1, weekDifference + 1)
    }

    private func calculateWeekStartDate() {
        let today = Date()
        let mondayOfCurrentWeek = startOfWeek(for: today)

        let weeksFromCurrent = currentWeek - getCurrentAcademicWeek()

        if let adjustedMonday = calendar.date(byAdding: .weekOfYear, value: weeksFromCurrent, to: mondayOfCurrentWeek) {
            currentWeekStartDate = adjustedMonday
        }
    }

    func getDateForDay(dayIndex: Int) -> Date? {
        // Пн = 1 -> offset 0
        // Вт = 2 -> offset 1
        // ...
        // Вс = 7 -> offset 6
        let dayOffset = dayIndex - 1
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

        // Calendar: 1 = Sunday, 2 = Monday ... 7 = Saturday
        // Нам надо: Monday = 1 ... Sunday = 7
        currentDayIndex = weekday == 1 ? 7 : weekday - 1

        currentWeek = getCurrentAcademicWeek()
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

        if currentWeek > 1 {
            currentWeek -= 1
        }

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
