import Foundation

enum DateFormatting {
    private static let workoutDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .none
        return f
    }()

    private static let shortDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "M/d/yy"
        return f
    }()

    static func workoutDate(_ date: Date) -> String {
        workoutDateFormatter.string(from: date)
    }

    static func shortDate(_ date: Date) -> String {
        shortDateFormatter.string(from: date)
    }

    static func relativeDays(from date: Date, to now: Date = Date()) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: calendar.startOfDay(for: date), to: calendar.startOfDay(for: now))
        return components.day ?? 0
    }

    static func relativeDescription(from date: Date, to now: Date = Date()) -> String {
        let days = relativeDays(from: date, to: now)
        switch days {
        case 0: return "Today"
        case 1: return "Yesterday"
        default: return "\(days) days ago"
        }
    }
}
