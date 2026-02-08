import Foundation

struct RecoveryAnalyzer {
    struct MuscleGroupStatus {
        let muscleGroup: MuscleGroup
        let hoursSinceLastWorked: Double?
        let isRecovered: Bool
        let recoveryPercentage: Double
    }

    func analyze(workouts: [Workout], asOf: Date = Date()) -> [MuscleGroupStatus] {
        // Find most recent workout date for each muscle group
        var lastWorked: [MuscleGroup: Date] = [:]

        for workout in workouts {
            for exercise in workout.exercises {
                if let definition = ExerciseDefinition.lookup(exercise.normalizedName) {
                    for muscle in definition.primaryMuscles + definition.secondaryMuscles {
                        if let existing = lastWorked[muscle] {
                            if workout.date > existing {
                                lastWorked[muscle] = workout.date
                            }
                        } else {
                            lastWorked[muscle] = workout.date
                        }
                    }
                }
            }
        }

        return MuscleGroup.allCases.map { group in
            if let lastDate = lastWorked[group] {
                let hours = asOf.timeIntervalSince(lastDate) / 3600.0
                let minRecovery = Double(group.minimumRecoveryHours)
                let recoveryPct = min(hours / minRecovery, 1.5)
                return MuscleGroupStatus(
                    muscleGroup: group,
                    hoursSinceLastWorked: hours,
                    isRecovered: hours >= minRecovery,
                    recoveryPercentage: recoveryPct
                )
            } else {
                return MuscleGroupStatus(
                    muscleGroup: group,
                    hoursSinceLastWorked: nil,
                    isRecovered: true,
                    recoveryPercentage: 1.5
                )
            }
        }
    }

    func readyMuscleGroups(workouts: [Workout], asOf: Date = Date()) -> [MuscleGroup] {
        analyze(workouts: workouts, asOf: asOf)
            .filter { $0.isRecovered }
            .sorted { ($0.hoursSinceLastWorked ?? .infinity) > ($1.hoursSinceLastWorked ?? .infinity) }
            .map(\.muscleGroup)
    }
}
