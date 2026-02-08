import Foundation

struct RecommendationEngine {
    private let overloadAnalyzer = ProgressiveOverloadAnalyzer()
    private let recoveryAnalyzer = RecoveryAnalyzer()
    private let volumeAnalyzer = VolumeAnalyzer()

    struct DayRecommendation {
        let title: String
        let summary: String
        let exercises: [WorkoutRecommendation]
        let targetMuscleGroups: [MuscleGroup]
        let recoveryNotes: [String]
    }

    func generateDayRecommendation(
        from workouts: [Workout],
        goal: FitnessGoal,
        asOf: Date = Date()
    ) -> DayRecommendation {
        let readyGroups = Set(recoveryAnalyzer.readyMuscleGroups(workouts: workouts, asOf: asOf))
        let undertrainedGroups = Set(volumeAnalyzer.undertrainedGroups(workouts: workouts, asOf: asOf))
        let trends = overloadAnalyzer.analyze(workouts: workouts)

        // Priority: muscle groups that are both recovered AND undertrained
        let priorityGroups = readyGroups.intersection(undertrainedGroups)

        // Build recommendations for exercises the user has done before
        var recommendations: [WorkoutRecommendation] = []
        var coveredMuscles = Set<MuscleGroup>()

        for trend in trends {
            guard let definition = ExerciseDefinition.lookup(trend.canonicalName) else { continue }

            let primaryReady = !Set(definition.primaryMuscles).intersection(readyGroups).isEmpty
            guard primaryReady else { continue }

            let isPriority = !Set(definition.primaryMuscles).intersection(priorityGroups).isEmpty
            let (weight, reps) = overloadAnalyzer.suggestProgression(trend: trend, goal: goal)

            let reasoning = buildReasoning(
                trend: trend,
                goal: goal,
                isPriority: isPriority,
                definition: definition,
                readyGroups: readyGroups
            )

            recommendations.append(WorkoutRecommendation(
                exerciseName: trend.exerciseName,
                suggestedSets: goal.targetSets,
                suggestedReps: reps,
                suggestedWeight: weight,
                reasoning: reasoning,
                priority: isPriority ? .high : .medium,
                muscleGroups: definition.primaryMuscles
            ))

            coveredMuscles.formUnion(definition.primaryMuscles)
        }

        // Sort: high priority first, then by most recently trained (freshest movement patterns)
        recommendations.sort { a, b in
            if a.priority != b.priority { return a.priority > b.priority }
            return a.exerciseName < b.exerciseName
        }

        // Limit to a reasonable workout size (5-7 exercises)
        let selected = selectBalancedWorkout(from: recommendations, goal: goal)

        // Recovery notes
        let recoveryStatuses = recoveryAnalyzer.analyze(workouts: workouts, asOf: asOf)
        var notes: [String] = []
        let notRecovered = recoveryStatuses.filter { !$0.isRecovered }
        if !notRecovered.isEmpty {
            let names = notRecovered.map(\.muscleGroup.displayName).joined(separator: ", ")
            notes.append("Still recovering: \(names)")
        }

        // Determine target muscle groups from selected exercises
        let targetGroups = Array(Set(selected.flatMap(\.muscleGroups))).sorted { $0.displayName < $1.displayName }

        let title = generateTitle(for: targetGroups)
        let summary = generateSummary(exerciseCount: selected.count, goal: goal, targetGroups: targetGroups)

        return DayRecommendation(
            title: title,
            summary: summary,
            exercises: selected,
            targetMuscleGroups: targetGroups,
            recoveryNotes: notes
        )
    }

    private func selectBalancedWorkout(from all: [WorkoutRecommendation], goal: FitnessGoal) -> [WorkoutRecommendation] {
        guard all.count > 7 else { return all }

        var selected: [WorkoutRecommendation] = []
        var coveredGroups = Set<MuscleGroup>()

        // First pass: take one high-priority per muscle group
        for rec in all where rec.priority == .high {
            let newMuscles = Set(rec.muscleGroups).subtracting(coveredGroups)
            if !newMuscles.isEmpty {
                selected.append(rec)
                coveredGroups.formUnion(rec.muscleGroups)
            }
        }

        // Second pass: fill remaining slots with medium priority
        for rec in all where rec.priority == .medium && selected.count < 7 {
            let newMuscles = Set(rec.muscleGroups).subtracting(coveredGroups)
            if !newMuscles.isEmpty || selected.count < 5 {
                selected.append(rec)
                coveredGroups.formUnion(rec.muscleGroups)
            }
        }

        return Array(selected.prefix(7))
    }

    private func buildReasoning(
        trend: ProgressiveOverloadAnalyzer.ExerciseTrend,
        goal: FitnessGoal,
        isPriority: Bool,
        definition: ExerciseDefinition,
        readyGroups: Set<MuscleGroup>
    ) -> String {
        var parts: [String] = []

        switch trend.trend {
        case .progressing:
            parts.append("You've been making progress. Time to push the weight up slightly.")
        case .plateau:
            if trend.lastReps >= goal.targetRepRange.upperBound {
                parts.append("You've hit the top of the rep range at this weight. Ready to increase load.")
            } else {
                parts.append("Progress has stalled. Focus on hitting more reps at current weight.")
            }
        case .regressing:
            parts.append("Performance has dipped recently. A slight deload will help you rebuild momentum.")
        case .insufficient:
            parts.append("Limited history for this exercise. Maintain current weights and focus on form.")
        }

        if isPriority {
            let muscleNames = definition.primaryMuscles.map(\.displayName).joined(separator: "/")
            parts.append("\(muscleNames) could use more volume this week.")
        }

        return parts.joined(separator: " ")
    }

    private func generateTitle(for groups: [MuscleGroup]) -> String {
        if groups.isEmpty { return "Rest Day" }

        let primary = Set(groups)
        if primary.contains(.chest) && primary.contains(.triceps) {
            return "Push Day"
        }
        if primary.contains(.back) || primary.contains(.lats) {
            if primary.contains(.biceps) { return "Pull Day" }
            return "Back Day"
        }
        if primary.contains(.quadriceps) || primary.contains(.hamstrings) || primary.contains(.glutes) {
            return "Leg Day"
        }
        if primary.contains(.shoulders) {
            return "Shoulder Day"
        }
        if primary.contains(.chest) {
            return "Chest Day"
        }

        let names = groups.prefix(3).map(\.displayName).joined(separator: " & ")
        return "\(names) Day"
    }

    private func generateSummary(exerciseCount: Int, goal: FitnessGoal, targetGroups: [MuscleGroup]) -> String {
        let groupNames = targetGroups.prefix(4).map(\.displayName).joined(separator: ", ")
        return "\(exerciseCount) exercises targeting \(groupNames). Goal: \(goal.displayName) (\(goal.targetRepRange.lowerBound)-\(goal.targetRepRange.upperBound) reps)."
    }
}
