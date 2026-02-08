import Foundation

struct ParsedWorkout {
    let date: Date
    let exercises: [ParsedExercise]
    let rawText: String
}

struct ParsedExercise {
    let name: String
    let sets: [ParsedSet]
}

struct ParsedSet {
    let weight: Double
    let reps: Int
}

enum ParseError: Error, LocalizedError {
    case noDateFound
    case invalidSetFormat(line: String)
    case emptyWorkout
    case invalidDate(line: String)

    var errorDescription: String? {
        switch self {
        case .noDateFound:
            return "No date found at the start of the workout"
        case .invalidSetFormat(let line):
            return "Could not parse set: \"\(line)\""
        case .emptyWorkout:
            return "Workout contains no exercises"
        case .invalidDate(let line):
            return "Invalid date format: \"\(line)\""
        }
    }
}
