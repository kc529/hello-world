import Foundation

struct WorkoutParser {
    private let dateParser = DateParser()
    private let setParser = SetParser()

    /// Parses a full text block potentially containing multiple workouts.
    func parse(_ text: String) throws -> [ParsedWorkout] {
        let lines = text.components(separatedBy: .newlines)
        var workouts: [ParsedWorkout] = []

        var currentDate: Date?
        var currentExercises: [ParsedExercise] = []
        var currentExerciseName: String?
        var currentSets: [ParsedSet] = []
        var workoutStartIndex = 0

        func flushExercise() {
            if let name = currentExerciseName, !currentSets.isEmpty {
                currentExercises.append(ParsedExercise(name: name, sets: currentSets))
            }
            currentExerciseName = nil
            currentSets = []
        }

        func flushWorkout(endIndex: Int) {
            flushExercise()
            if let date = currentDate, !currentExercises.isEmpty {
                let rawSlice = lines[workoutStartIndex..<endIndex].joined(separator: "\n")
                workouts.append(ParsedWorkout(date: date, exercises: currentExercises, rawText: rawSlice))
            }
            currentDate = nil
            currentExercises = []
        }

        for (index, rawLine) in lines.enumerated() {
            let line = rawLine.trimmingCharacters(in: .whitespaces)

            if line.isEmpty {
                flushExercise()
                continue
            }

            if dateParser.looksLikeDate(line) {
                flushWorkout(endIndex: index)
                guard let date = dateParser.parse(line) else {
                    throw ParseError.invalidDate(line: line)
                }
                currentDate = date
                workoutStartIndex = index
                continue
            }

            if setParser.looksLikeSet(line) {
                let sets = try setParser.parse(line)
                currentSets.append(contentsOf: sets)
            } else {
                flushExercise()
                currentExerciseName = line
            }
        }

        flushWorkout(endIndex: lines.count)
        return workouts
    }
}
