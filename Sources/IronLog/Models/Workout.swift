import Foundation
import SwiftData

@Model
final class Workout {
    var date: Date
    var rawText: String
    var createdAt: Date

    @Relationship(deleteRule: .cascade, inverse: \ExerciseRecord.workout)
    var exercises: [ExerciseRecord] = []

    init(date: Date, rawText: String = "") {
        self.date = date
        self.rawText = rawText
        self.createdAt = Date()
    }

    var sortedExercises: [ExerciseRecord] {
        exercises.sorted { $0.orderIndex < $1.orderIndex }
    }

    var muscleGroupsWorked: Set<MuscleGroup> {
        var groups = Set<MuscleGroup>()
        for exercise in exercises {
            if let definition = ExerciseDefinition.lookup(exercise.normalizedName) {
                groups.formUnion(definition.primaryMuscles)
                groups.formUnion(definition.secondaryMuscles)
            }
        }
        return groups
    }

    var totalVolume: Double {
        exercises.reduce(0) { $0 + $1.totalVolume }
    }

    var totalSets: Int {
        exercises.reduce(0) { $0 + $1.sets.count }
    }

    var exerciseNames: [String] {
        sortedExercises.map(\.name)
    }
}
