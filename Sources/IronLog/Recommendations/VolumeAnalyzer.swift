import Foundation

struct VolumeAnalyzer {
    struct WeeklyVolume {
        let muscleGroup: MuscleGroup
        let averageWeeklySets: Double
        let totalVolume: Double
        let assessment: VolumeAssessment
    }

    enum VolumeAssessment {
        case underTraining
        case optimal
        case overReaching

        var description: String {
            switch self {
            case .underTraining: return "Under-trained"
            case .optimal: return "Optimal"
            case .overReaching: return "High volume"
            }
        }
    }

    static let optimalWeeklySets: [MuscleGroup: ClosedRange<Int>] = [
        .chest: 10...20,
        .back: 10...20,
        .lats: 10...20,
        .shoulders: 8...16,
        .biceps: 8...14,
        .triceps: 8...14,
        .quadriceps: 10...20,
        .hamstrings: 8...16,
        .glutes: 8...16,
        .calves: 8...14,
        .core: 6...12,
        .forearms: 4...8,
        .traps: 6...12,
    ]

    func analyze(workouts: [Workout], weeks: Int = 4, asOf: Date = Date()) -> [WeeklyVolume] {
        let cutoff = Calendar.current.date(byAdding: .weekOfYear, value: -weeks, to: asOf) ?? asOf
        let recentWorkouts = workouts.filter { $0.date >= cutoff }

        // Count sets per muscle group
        var setsPerGroup: [MuscleGroup: Int] = [:]
        var volumePerGroup: [MuscleGroup: Double] = [:]

        for workout in recentWorkouts {
            for exercise in workout.exercises {
                if let definition = ExerciseDefinition.lookup(exercise.normalizedName) {
                    let setCount = exercise.sets.count
                    let volume = exercise.totalVolume

                    for muscle in definition.primaryMuscles {
                        setsPerGroup[muscle, default: 0] += setCount
                        volumePerGroup[muscle, default: 0] += volume
                    }
                    // Secondary muscles get half credit for set counting
                    for muscle in definition.secondaryMuscles {
                        setsPerGroup[muscle, default: 0] += max(setCount / 2, 1)
                        volumePerGroup[muscle, default: 0] += volume * 0.5
                    }
                }
            }
        }

        let weekCount = max(Double(weeks), 1)

        return MuscleGroup.allCases.map { group in
            let totalSets = setsPerGroup[group] ?? 0
            let avgWeekly = Double(totalSets) / weekCount
            let totalVol = volumePerGroup[group] ?? 0

            let assessment: VolumeAssessment
            if let optimal = Self.optimalWeeklySets[group] {
                if avgWeekly < Double(optimal.lowerBound) {
                    assessment = .underTraining
                } else if avgWeekly > Double(optimal.upperBound) {
                    assessment = .overReaching
                } else {
                    assessment = .optimal
                }
            } else {
                assessment = .optimal
            }

            return WeeklyVolume(
                muscleGroup: group,
                averageWeeklySets: avgWeekly,
                totalVolume: totalVol,
                assessment: assessment
            )
        }
    }

    func undertrainedGroups(workouts: [Workout], asOf: Date = Date()) -> [MuscleGroup] {
        analyze(workouts: workouts, asOf: asOf)
            .filter { $0.assessment == .underTraining }
            .sorted { $0.averageWeeklySets < $1.averageWeeklySets }
            .map(\.muscleGroup)
    }
}
