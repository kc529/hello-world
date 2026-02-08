import Foundation

enum WeightFormatting {
    /// Round to nearest standard plate increment (2.5 lbs)
    static func roundToPlate(_ weight: Double) -> Double {
        (weight / 2.5).rounded() * 2.5
    }

    /// Format weight for display: "135 lbs" or "22.5 lbs"
    static func display(_ weight: Double) -> String {
        if weight == weight.rounded() {
            return "\(Int(weight)) lbs"
        } else {
            return String(format: "%.1f lbs", weight)
        }
    }

    /// Compact format: "135" or "22.5"
    static func compact(_ weight: Double) -> String {
        if weight == weight.rounded() {
            return "\(Int(weight))"
        } else {
            return String(format: "%.1f", weight)
        }
    }
}
