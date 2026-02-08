import Foundation
import SwiftData

@Model
final class ExerciseRecord {
    var name: String
    var normalizedName: String
    var orderIndex: Int
    var workout: Workout?

    @Relationship(deleteRule: .cascade, inverse: \SetRecord.exercise)
    var sets: [SetRecord] = []

    init(name: String, orderIndex: Int) {
        self.name = name
        self.normalizedName = name.lowercased().trimmingCharacters(in: .whitespaces)
        self.orderIndex = orderIndex
    }

    var totalVolume: Double {
        sets.reduce(0) { $0 + $1.volume }
    }

    var sortedSets: [SetRecord] {
        sets.sorted { $0.setNumber < $1.setNumber }
    }

    /// Best estimated 1RM across all sets
    var bestEstimated1RM: Double {
        sets.map(\.estimated1RM).max() ?? 0
    }

    /// Top working weight used
    var topWeight: Double {
        sets.map(\.weight).max() ?? 0
    }

    /// Best reps at top weight
    var bestRepsAtTopWeight: Int {
        let maxWeight = topWeight
        return sets.filter { $0.weight == maxWeight }.map(\.reps).max() ?? 0
    }
}
