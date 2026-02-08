import Foundation
import SwiftData

@Model
final class SetRecord {
    var weight: Double
    var reps: Int
    var setNumber: Int
    var exercise: ExerciseRecord?

    init(weight: Double, reps: Int, setNumber: Int) {
        self.weight = weight
        self.reps = reps
        self.setNumber = setNumber
    }

    var volume: Double {
        weight * Double(reps)
    }

    /// Estimated one-rep max using Brzycki formula
    var estimated1RM: Double {
        guard reps > 0 && reps <= 36 else { return weight }
        if reps == 1 { return weight }
        return weight * (36.0 / (37.0 - Double(reps)))
    }
}
