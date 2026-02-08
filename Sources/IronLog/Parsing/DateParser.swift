import Foundation

struct DateParser {
    /// Parses date strings like "1/29/26", "01/29/26", "1/29/2026"
    func parse(_ line: String) -> Date? {
        let trimmed = line.trimmingCharacters(in: .whitespaces)
        let components = trimmed.split(separator: "/")
        guard components.count == 3,
              let month = Int(components[0]),
              let day = Int(components[1]),
              var year = Int(components[2]) else {
            return nil
        }
        if year < 100 { year += 2000 }

        var dateComponents = DateComponents()
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.year = year
        return Calendar.current.date(from: dateComponents)
    }

    /// Checks if a line looks like a date line
    func looksLikeDate(_ line: String) -> Bool {
        let pattern = #"^\d{1,2}/\d{1,2}/\d{2,4}$"#
        return line.trimmingCharacters(in: .whitespaces)
            .range(of: pattern, options: .regularExpression) != nil
    }
}
