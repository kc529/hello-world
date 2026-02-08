import Foundation

struct WorkoutRecommendation: Identifiable {
    let id = UUID()
    let exerciseName: String
    let suggestedSets: Int
    let suggestedReps: ClosedRange<Int>
    let suggestedWeight: Double
    let reasoning: String
    let priority: RecommendationPriority
    let muscleGroups: [MuscleGroup]
}

enum RecommendationPriority: Int, Comparable {
    case high = 3
    case medium = 2
    case low = 1

    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    var label: String {
        switch self {
        case .high: return "High"
        case .medium: return "Medium"
        case .low: return "Low"
        }
    }

    var color: String {
        switch self {
        case .high: return "red"
        case .medium: return "orange"
        case .low: return "blue"
        }
    }
}

enum FitnessGoal: String, Codable, CaseIterable, Identifiable {
    case strength
    case hypertrophy
    case endurance

    var id: String { rawValue }

    var targetRepRange: ClosedRange<Int> {
        switch self {
        case .strength: return 3...5
        case .hypertrophy: return 8...12
        case .endurance: return 15...20
        }
    }

    var targetSets: Int {
        switch self {
        case .strength: return 5
        case .hypertrophy: return 4
        case .endurance: return 3
        }
    }

    var displayName: String {
        rawValue.capitalized
    }

    var description: String {
        switch self {
        case .strength: return "Heavy weight, low reps (3-5)"
        case .hypertrophy: return "Moderate weight, medium reps (8-12)"
        case .endurance: return "Light weight, high reps (15-20)"
        }
    }
}
