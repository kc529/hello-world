import Foundation

struct SetParser {
    /// Parses a single set line into one or more ParsedSet values.
    ///
    /// Supported formats:
    ///   "50 x 6"        -> [ParsedSet(weight: 50, reps: 6)]
    ///   "50 lbs x 6"    -> [ParsedSet(weight: 50, reps: 6)]
    ///   "25 x 8 x 3"    -> 3x [ParsedSet(weight: 25, reps: 8)]
    func parse(_ line: String) throws -> [ParsedSet] {
        let trimmed = line.trimmingCharacters(in: .whitespaces).lowercased()
        let cleaned = trimmed.replacingOccurrences(of: "lbs", with: "")

        let parts = cleaned.split(separator: "x").map {
            $0.trimmingCharacters(in: .whitespaces)
        }

        guard parts.count >= 2,
              let weight = Double(parts[0]),
              let reps = Int(parts[1]) else {
            throw ParseError.invalidSetFormat(line: line)
        }

        let setCount: Int
        if parts.count >= 3, let count = Int(parts[2]) {
            setCount = count
        } else {
            setCount = 1
        }

        return Array(repeating: ParsedSet(weight: weight, reps: reps), count: setCount)
    }

    /// Checks if a line looks like a set line
    func looksLikeSet(_ line: String) -> Bool {
        let pattern = #"^\d+(\.\d+)?\s*(lbs\s*)?x\s*\d+"#
        return line.trimmingCharacters(in: .whitespaces)
            .range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil
    }
}
