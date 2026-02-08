import Foundation

struct ProgressiveOverloadAnalyzer {
    struct ExerciseTrend {
        let exerciseName: String
        let canonicalName: String
        let recentEstimated1RM: [Double]
        let lastWeight: Double
        let lastReps: Int
        let trend: Trend
        let lastWorkoutDate: Date
    }

    enum Trend {
        case progressing
        case plateau
        case regressing
        case insufficient

        var description: String {
            switch self {
            case .progressing: return "Progressing"
            case .plateau: return "Plateau"
            case .regressing: return "Regressing"
            case .insufficient: return "Not enough data"
            }
        }
    }

    func analyze(workouts: [Workout], windowSize: Int = 6) -> [ExerciseTrend] {
        // Group exercise records by normalized name, sorted by date
        var exerciseHistory: [String: [(date: Date, record: ExerciseRecord)]] = [:]

        for workout in workouts.sorted(by: { $0.date < $1.date }) {
            for exercise in workout.exercises {
                let key = exercise.normalizedName
                exerciseHistory[key, default: []].append((date: workout.date, record: exercise))
            }
        }

        return exerciseHistory.compactMap { (name, history) in
            let recent = Array(history.suffix(windowSize))
            guard let last = recent.last else { return nil }

            let e1RMs = recent.map { $0.record.bestEstimated1RM }
            let trend = determineTrend(values: e1RMs)

            let displayName = last.record.name
            let canonical = ExerciseDefinition.lookup(name)?.canonicalName ?? name

            return ExerciseTrend(
                exerciseName: displayName,
                canonicalName: canonical,
                recentEstimated1RM: e1RMs,
                lastWeight: last.record.topWeight,
                lastReps: last.record.bestRepsAtTopWeight,
                trend: trend,
                lastWorkoutDate: last.date
            )
        }
    }

    private func determineTrend(values: [Double]) -> Trend {
        guard values.count >= 2 else { return .insufficient }

        if values.count >= 3 {
            // Check last 3 values for plateau (less than 2% variation)
            let last3 = Array(values.suffix(3))
            let avg = last3.reduce(0, +) / Double(last3.count)
            let maxDeviation = last3.map { abs($0 - avg) / avg }.max() ?? 0
            if maxDeviation < 0.02 {
                return .plateau
            }
        }

        // Simple linear trend: compare first half average to second half average
        let mid = values.count / 2
        let firstHalf = Array(values.prefix(mid))
        let secondHalf = Array(values.suffix(mid))

        let firstAvg = firstHalf.reduce(0, +) / max(Double(firstHalf.count), 1)
        let secondAvg = secondHalf.reduce(0, +) / max(Double(secondHalf.count), 1)

        let change = (secondAvg - firstAvg) / max(firstAvg, 1)

        if change > 0.02 {
            return .progressing
        } else if change < -0.02 {
            return .regressing
        } else {
            return .plateau
        }
    }

    func suggestProgression(trend: ExerciseTrend, goal: FitnessGoal) -> (weight: Double, reps: ClosedRange<Int>) {
        let targetReps = goal.targetRepRange

        switch trend.trend {
        case .progressing:
            // Keep pushing: small weight increase
            let newWeight = WeightFormatting.roundToPlate(trend.lastWeight + 5)
            return (newWeight, targetReps)

        case .plateau:
            // Break plateau: if at top of rep range, increase weight; otherwise push reps
            if trend.lastReps >= targetReps.upperBound {
                let newWeight = WeightFormatting.roundToPlate(trend.lastWeight + 5)
                return (newWeight, targetReps.lowerBound...targetReps.lowerBound + 2)
            } else {
                return (trend.lastWeight, targetReps)
            }

        case .regressing:
            // Deload: reduce weight by 10%, rebuild
            let deloadWeight = WeightFormatting.roundToPlate(trend.lastWeight * 0.9)
            return (deloadWeight, targetReps)

        case .insufficient:
            return (trend.lastWeight, targetReps)
        }
    }
}
