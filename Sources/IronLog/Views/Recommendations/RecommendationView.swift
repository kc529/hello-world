import SwiftUI
import SwiftData

struct RecommendationView: View {
    @Query(sort: \Workout.date, order: .reverse) private var workouts: [Workout]
    @AppStorage("fitnessGoal") private var goalRaw: String = FitnessGoal.hypertrophy.rawValue
    private let engine = RecommendationEngine()

    private var goal: FitnessGoal {
        FitnessGoal(rawValue: goalRaw) ?? .hypertrophy
    }

    private var recommendation: RecommendationEngine.DayRecommendation {
        engine.generateDayRecommendation(from: workouts, goal: goal)
    }

    var body: some View {
        NavigationStack {
            Group {
                if workouts.isEmpty {
                    ContentUnavailableView(
                        "No Data Yet",
                        systemImage: "chart.line.uptrend.xyaxis",
                        description: Text("Log a few workouts first and we'll recommend your next session based on your performance, recovery, and goals.")
                    )
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            goalPicker
                            headerCard
                            recoveryNotes
                            exerciseList
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Today's Workout")
        }
    }

    private var goalPicker: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Training Goal")
                .font(.caption)
                .foregroundStyle(.secondary)
            Picker("Goal", selection: $goalRaw) {
                ForEach(FitnessGoal.allCases) { g in
                    Text(g.displayName).tag(g.rawValue)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "figure.strengthtraining.traditional")
                    .font(.title2)
                    .foregroundStyle(.blue)
                Text(recommendation.title)
                    .font(.title2.bold())
                Spacer()
            }

            Text(recommendation.summary)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            if !recommendation.targetMuscleGroups.isEmpty {
                FlowLayout(spacing: 6) {
                    ForEach(recommendation.targetMuscleGroups) { group in
                        Text(group.displayName)
                            .font(.caption2.bold())
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.15))
                            .clipShape(Capsule())
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    @ViewBuilder
    private var recoveryNotes: some View {
        if !recommendation.recoveryNotes.isEmpty {
            VStack(alignment: .leading, spacing: 4) {
                ForEach(recommendation.recoveryNotes, id: \.self) { note in
                    HStack(alignment: .top) {
                        Image(systemName: "bed.double.fill")
                            .foregroundStyle(.orange)
                            .font(.caption)
                        Text(note)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding()
            .background(Color.orange.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }

    private var exerciseList: some View {
        VStack(alignment: .leading, spacing: 12) {
            if recommendation.exercises.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "zzz")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                    Text("All muscle groups are still recovering.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("Consider a rest day or light cardio.")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 32)
            } else {
                Text("Exercises")
                    .font(.headline)

                ForEach(recommendation.exercises) { rec in
                    RecommendationCardView(recommendation: rec)
                }
            }
        }
    }
}
