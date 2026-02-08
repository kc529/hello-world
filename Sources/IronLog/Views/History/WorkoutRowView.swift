import SwiftUI

struct WorkoutRowView: View {
    let workout: Workout

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(DateFormatting.workoutDate(workout.date))
                    .font(.headline)
                Spacer()
                Text(DateFormatting.relativeDescription(from: workout.date))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Text(workout.exerciseNames.joined(separator: ", "))
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)

            HStack(spacing: 16) {
                Label("\(workout.exercises.count)", systemImage: "figure.strengthtraining.traditional")
                Label("\(workout.totalSets)", systemImage: "arrow.up.arrow.down")
                if workout.totalVolume > 0 {
                    Label(volumeText, systemImage: "scalemass")
                }
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }

    private var volumeText: String {
        let vol = workout.totalVolume
        if vol >= 1000 {
            return String(format: "%.1fK lbs", vol / 1000)
        }
        return "\(Int(vol)) lbs"
    }
}
