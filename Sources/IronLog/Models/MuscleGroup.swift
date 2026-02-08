import Foundation

enum MuscleGroup: String, Codable, CaseIterable, Identifiable {
    case chest
    case back
    case shoulders
    case biceps
    case triceps
    case quadriceps
    case hamstrings
    case glutes
    case calves
    case core
    case forearms
    case traps
    case lats

    var id: String { rawValue }

    /// Recommended minimum recovery hours before training again
    var minimumRecoveryHours: Int {
        switch self {
        case .chest, .back, .lats, .quadriceps, .hamstrings, .glutes:
            return 72
        case .shoulders, .traps, .core:
            return 48
        case .biceps, .triceps, .calves, .forearms:
            return 48
        }
    }

    var displayName: String {
        switch self {
        case .quadriceps: return "Quads"
        case .hamstrings: return "Hamstrings"
        default: return rawValue.capitalized
        }
    }
}
