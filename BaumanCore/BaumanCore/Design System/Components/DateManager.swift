import Foundation
import SwiftUI

final class ScheduleDateManager: ObservableObject {
    @Published var currentWeek: Int = 1
    @Published var currentDayIndex: Int = 1
    @Published var isEvenWeek: Bool = false
    @Published var currentWeekStartDate: Date = Date()
    @Published var animateDayButtons: Bool = false

    private var calendar: Calendar = {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        return calendar
    }()

    private let maxWeeks = 18

    init() {
        updateRealDate()
    }

    private func makeDate(year: Int, month: Int, day: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        return calendar.date(from: components)!
    }

    private func firstStudyDay(from date: Date) -> Date {
        let weekday = calendar.component(.weekday, from: date)

        if weekday == 7 {
            return calendar.date(byAdding: .day, value: 2, to: date)!
        }

        if weekday == 1 {
            return calendar.date(byAdding: .day, value: 1, to: date)!
        }
        return date
    }

    private func fallSemesterStart(year: Int) -> Date {
        let septemberFirst = makeDate(year: year, month: 9, day: 1)
        return firstStudyDay(from: septemberFirst)
    }

    private func springSemesterStart(year: Int) -> Date {
        let februarySeventh = makeDate(year: year, month: 2, day: 7)
        return firstStudyDay(from: februarySeventh)
    }

    private func currentSemesterStart(for date: Date) -> Date {
        let year = calendar.component(.year, from: date)

        let springStart = springSemesterStart(year: year)
        let fallStart = fallSemesterStart(year: year)

        if date >= fallStart {
            return fallStart
        } else if date >= springStart {
            return springStart
        } else {
            return fallSemesterStart(year: year - 1)
        }
    }

    private func academicWeek(for date: Date) -> Int {
        let semesterStart = currentSemesterStart(for: date)

        let daysBetween = calendar.dateComponents([.day], from: semesterStart, to: date).day ?? 0
        let week = daysBetween / 7 + 1

        return min(max(week, 1), maxWeeks)
    }

    private func calculateWeekStartDate() {
        let semesterStart = currentSemesterStart(for: Date())

        currentWeekStartDate = calendar.date(
            byAdding: .weekOfYear,
            value: currentWeek - 1,
            to: semesterStart
        ) ?? semesterStart
    }

    func getDateForDay(dayIndex: Int) -> Date? {
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

        currentDayIndex = weekday == 1 ? 7 : weekday - 1

        currentWeek = academicWeek(for: today)
        isEvenWeek = currentWeek % 2 == 0

        calculateWeekStartDate()
    }

    func nextWeek() {
        withAnimation(.easeInOut(duration: 0.3)) {
            animateDayButtons = true
        }

        if currentWeek < maxWeeks {
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
    
    var weekTitle: LocalizedStringKey {
        isEvenWeek
        ? "schedule_week_title_even \(currentWeek)"
        : "schedule_week_title_odd \(currentWeek)"
    }
}
