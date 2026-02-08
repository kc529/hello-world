import SwiftUI

struct RecommendationCardView: View {
    let recommendation: WorkoutRecommendation

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Exercise name and priority
            HStack {
                Text(recommendation.exerciseName)
                    .font(.headline)
                Spacer()
                priorityBadge
            }

            // Muscle groups
            HStack(spacing: 4) {
                ForEach(recommendation.muscleGroups) { group in
                    Text(group.displayName)
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.secondary.opacity(0.15))
                        .clipShape(Capsule())
                }
            }

            // Prescription
            HStack(spacing: 20) {
                VStack {
                    Text("\(recommendation.suggestedSets)")
                        .font(.title3.bold())
                    Text("sets")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                VStack {
                    Text("\(recommendation.suggestedReps.lowerBound)-\(recommendation.suggestedReps.upperBound)")
                        .font(.title3.bold())
                    Text("reps")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                VStack {
                    Text(WeightFormatting.compact(recommendation.suggestedWeight))
                        .font(.title3.bold())
                    Text("lbs")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }

            // Reasoning
            Text(recommendation.reasoning)
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var priorityBadge: some View {
        Text(recommendation.priority.label)
            .font(.caption2.bold())
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(priorityColor.opacity(0.2))
            .foregroundStyle(priorityColor)
            .clipShape(Capsule())
    }

    private var priorityColor: Color {
        switch recommendation.priority {
        case .high: return .red
        case .medium: return .orange
        case .low: return .blue
        }
    }
}
