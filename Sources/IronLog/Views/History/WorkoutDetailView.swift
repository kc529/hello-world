import SwiftUI

struct WorkoutDetailView: View {
    let workout: Workout

    var body: some View {
        List {
            Section {
                HStack {
                    Text("Date")
                    Spacer()
                    Text(DateFormatting.workoutDate(workout.date))
                        .foregroundStyle(.secondary)
                }
                HStack {
                    Text("Exercises")
                    Spacer()
                    Text("\(workout.exercises.count)")
                        .foregroundStyle(.secondary)
                }
                HStack {
                    Text("Total Sets")
                    Spacer()
                    Text("\(workout.totalSets)")
                        .foregroundStyle(.secondary)
                }
                HStack {
                    Text("Total Volume")
                    Spacer()
                    Text(WeightFormatting.display(workout.totalVolume))
                        .foregroundStyle(.secondary)
                }
            } header: {
                Text("Summary")
            }

            if !workout.muscleGroupsWorked.isEmpty {
                Section {
                    FlowLayout(spacing: 8) {
                        ForEach(Array(workout.muscleGroupsWorked).sorted(by: { $0.displayName < $1.displayName })) { group in
                            Text(group.displayName)
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.blue.opacity(0.15))
                                .clipShape(Capsule())
                        }
                    }
                } header: {
                    Text("Muscle Groups")
                }
            }

            ForEach(workout.sortedExercises) { exercise in
                Section {
                    ForEach(exercise.sortedSets) { set in
                        HStack {
                            Text("Set \(set.setNumber)")
                                .foregroundStyle(.secondary)
                                .frame(width: 50, alignment: .leading)
                            Text(WeightFormatting.display(set.weight))
                            Spacer()
                            Text("\(set.reps) reps")
                                .foregroundStyle(.secondary)
                        }
                    }

                    HStack {
                        Text("Volume")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(WeightFormatting.display(exercise.totalVolume))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                } header: {
                    Text(exercise.name)
                }
            }
        }
        .navigationTitle("Workout Details")
    }
}

/// Simple flow layout for muscle group tags
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = layout(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = layout(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y), proposal: .unspecified)
        }
    }

    private func layout(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0
        var maxX: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentX + size.width > maxWidth && currentX > 0 {
                currentX = 0
                currentY += lineHeight + spacing
                lineHeight = 0
            }
            positions.append(CGPoint(x: currentX, y: currentY))
            lineHeight = max(lineHeight, size.height)
            currentX += size.width + spacing
            maxX = max(maxX, currentX)
        }

        return (CGSize(width: maxX, height: currentY + lineHeight), positions)
    }
}
