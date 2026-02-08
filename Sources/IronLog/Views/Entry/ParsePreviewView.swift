import SwiftUI

struct ParsePreviewView: View {
    let workout: ParsedWorkout

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "calendar")
                    .foregroundStyle(.blue)
                Text(DateFormatting.workoutDate(workout.date))
                    .font(.headline)
                Spacer()
                Text("\(workout.exercises.count) exercise\(workout.exercises.count == 1 ? "" : "s")")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            ForEach(Array(workout.exercises.enumerated()), id: \.offset) { _, exercise in
                VStack(alignment: .leading, spacing: 4) {
                    Text(exercise.name)
                        .font(.subheadline.bold())

                    ForEach(Array(exercise.sets.enumerated()), id: \.offset) { index, set in
                        HStack {
                            Text("Set \(index + 1)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .frame(width: 44, alignment: .leading)
                            Text("\(WeightFormatting.compact(set.weight)) x \(set.reps)")
                                .font(.caption.monospaced())
                        }
                    }
                }
                .padding(.leading, 8)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal)
    }
}
