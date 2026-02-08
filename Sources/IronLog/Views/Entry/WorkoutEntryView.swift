import SwiftUI
import SwiftData

struct WorkoutEntryView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var workoutText = ""
    @State private var parsePreview: [ParsedWorkout] = []
    @State private var parseError: String?
    @State private var showingSaveConfirmation = false
    @State private var savedCount = 0

    private let parser = WorkoutParser()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Text input area
                VStack(alignment: .leading, spacing: 8) {
                    Text("Paste or type your workout:")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                        .padding(.top, 8)

                    TextEditor(text: $workoutText)
                        .font(.body.monospaced())
                        .frame(minHeight: 200)
                        .padding(.horizontal, 8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                                .padding(.horizontal, 4)
                        )
                        .padding(.horizontal, 8)
                }

                Divider()
                    .padding(.vertical, 8)

                // Parse preview
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        if let error = parseError {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundStyle(.yellow)
                                Text(error)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.horizontal)
                        }

                        if parsePreview.isEmpty && parseError == nil && !workoutText.isEmpty {
                            Text("Start with a date (e.g., 1/29/26) followed by exercises")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .padding(.horizontal)
                        }

                        ForEach(Array(parsePreview.enumerated()), id: \.offset) { _, workout in
                            ParsePreviewView(workout: workout)
                        }
                    }
                }

                // Save button
                Button(action: saveWorkouts) {
                    HStack {
                        Image(systemName: "square.and.arrow.down")
                        Text(parsePreview.count == 1 ? "Save Workout" : "Save \(parsePreview.count) Workouts")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(parsePreview.isEmpty ? Color.gray : Color.blue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .disabled(parsePreview.isEmpty)
                .padding()
            }
            .navigationTitle("Log Workout")
            .onChange(of: workoutText) { _, newValue in
                updatePreview(newValue)
            }
            .alert("Saved!", isPresented: $showingSaveConfirmation) {
                Button("OK") { }
            } message: {
                Text("\(savedCount) workout\(savedCount == 1 ? "" : "s") saved successfully.")
            }
        }
    }

    private func updatePreview(_ text: String) {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            parsePreview = []
            parseError = nil
            return
        }
        do {
            parsePreview = try parser.parse(text)
            parseError = nil
        } catch {
            parsePreview = []
            parseError = error.localizedDescription
        }
    }

    private func saveWorkouts() {
        for parsed in parsePreview {
            let workout = Workout(date: parsed.date, rawText: parsed.rawText)
            modelContext.insert(workout)

            for (exerciseIndex, parsedExercise) in parsed.exercises.enumerated() {
                let exercise = ExerciseRecord(name: parsedExercise.name, orderIndex: exerciseIndex)
                exercise.workout = workout

                for (setIndex, parsedSet) in parsedExercise.sets.enumerated() {
                    let setRecord = SetRecord(weight: parsedSet.weight, reps: parsedSet.reps, setNumber: setIndex + 1)
                    setRecord.exercise = exercise
                    exercise.sets.append(setRecord)
                }

                workout.exercises.append(exercise)
            }
        }

        savedCount = parsePreview.count
        workoutText = ""
        parsePreview = []
        showingSaveConfirmation = true
    }
}
