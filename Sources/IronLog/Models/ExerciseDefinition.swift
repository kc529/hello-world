import Foundation

struct ExerciseDefinition {
    let canonicalName: String
    let aliases: [String]
    let primaryMuscles: [MuscleGroup]
    let secondaryMuscles: [MuscleGroup]
    let category: ExerciseCategory

    enum ExerciseCategory: String, Codable {
        case compound
        case isolation
    }

    static let database: [ExerciseDefinition] = [
        // CHEST
        ExerciseDefinition(
            canonicalName: "dumbbell bench press",
            aliases: ["db bench press", "db bench", "dumbbell bench"],
            primaryMuscles: [.chest],
            secondaryMuscles: [.triceps, .shoulders],
            category: .compound
        ),
        ExerciseDefinition(
            canonicalName: "barbell bench press",
            aliases: ["bench press", "bb bench press", "flat bench"],
            primaryMuscles: [.chest],
            secondaryMuscles: [.triceps, .shoulders],
            category: .compound
        ),
        ExerciseDefinition(
            canonicalName: "dumbbell incline press",
            aliases: ["db incline press", "incline dumbbell press", "dumbbell incline bench", "incline db press", "incline press"],
            primaryMuscles: [.chest, .shoulders],
            secondaryMuscles: [.triceps],
            category: .compound
        ),
        ExerciseDefinition(
            canonicalName: "cable fly",
            aliases: ["cable flyes", "cable chest fly"],
            primaryMuscles: [.chest],
            secondaryMuscles: [],
            category: .isolation
        ),
        ExerciseDefinition(
            canonicalName: "dumbbell fly",
            aliases: ["db fly", "db flyes", "dumbbell flyes"],
            primaryMuscles: [.chest],
            secondaryMuscles: [],
            category: .isolation
        ),
        ExerciseDefinition(
            canonicalName: "push up",
            aliases: ["pushup", "push ups", "pushups"],
            primaryMuscles: [.chest],
            secondaryMuscles: [.triceps, .shoulders, .core],
            category: .compound
        ),

        // BACK
        ExerciseDefinition(
            canonicalName: "barbell row",
            aliases: ["bb row", "bent over row", "bent over barbell row"],
            primaryMuscles: [.back, .lats],
            secondaryMuscles: [.biceps, .forearms],
            category: .compound
        ),
        ExerciseDefinition(
            canonicalName: "dumbbell row",
            aliases: ["db row", "one arm dumbbell row", "single arm row"],
            primaryMuscles: [.back, .lats],
            secondaryMuscles: [.biceps, .forearms],
            category: .compound
        ),
        ExerciseDefinition(
            canonicalName: "pull up",
            aliases: ["pullup", "pull ups", "pullups", "chin up", "chinup"],
            primaryMuscles: [.lats, .back],
            secondaryMuscles: [.biceps],
            category: .compound
        ),
        ExerciseDefinition(
            canonicalName: "lat pulldown",
            aliases: ["cable pulldown", "wide grip pulldown"],
            primaryMuscles: [.lats],
            secondaryMuscles: [.biceps],
            category: .compound
        ),
        ExerciseDefinition(
            canonicalName: "seated cable row",
            aliases: ["cable row", "seated row"],
            primaryMuscles: [.back, .lats],
            secondaryMuscles: [.biceps, .forearms],
            category: .compound
        ),
        ExerciseDefinition(
            canonicalName: "deadlift",
            aliases: ["conventional deadlift", "barbell deadlift"],
            primaryMuscles: [.back, .hamstrings, .glutes],
            secondaryMuscles: [.forearms, .traps, .core],
            category: .compound
        ),

        // SHOULDERS
        ExerciseDefinition(
            canonicalName: "overhead press",
            aliases: ["ohp", "barbell overhead press", "military press", "standing press"],
            primaryMuscles: [.shoulders],
            secondaryMuscles: [.triceps, .core],
            category: .compound
        ),
        ExerciseDefinition(
            canonicalName: "dumbbell shoulder press",
            aliases: ["db shoulder press", "standing db shoulder press", "seated db shoulder press", "standing dumbbell shoulder press", "seated dumbbell shoulder press", "db overhead press", "dumbbell overhead press"],
            primaryMuscles: [.shoulders],
            secondaryMuscles: [.triceps],
            category: .compound
        ),
        ExerciseDefinition(
            canonicalName: "lateral raise",
            aliases: ["side raise", "db lateral raise", "dumbbell lateral raise", "side lateral raise"],
            primaryMuscles: [.shoulders],
            secondaryMuscles: [],
            category: .isolation
        ),
        ExerciseDefinition(
            canonicalName: "face pull",
            aliases: ["cable face pull"],
            primaryMuscles: [.shoulders, .traps],
            secondaryMuscles: [.back],
            category: .isolation
        ),
        ExerciseDefinition(
            canonicalName: "reverse fly",
            aliases: ["rear delt fly", "reverse dumbbell fly", "db reverse fly"],
            primaryMuscles: [.shoulders],
            secondaryMuscles: [.traps, .back],
            category: .isolation
        ),

        // ARMS
        ExerciseDefinition(
            canonicalName: "barbell curl",
            aliases: ["bb curl", "standing barbell curl"],
            primaryMuscles: [.biceps],
            secondaryMuscles: [.forearms],
            category: .isolation
        ),
        ExerciseDefinition(
            canonicalName: "dumbbell curl",
            aliases: ["db curl", "bicep curl", "standing dumbbell curl"],
            primaryMuscles: [.biceps],
            secondaryMuscles: [.forearms],
            category: .isolation
        ),
        ExerciseDefinition(
            canonicalName: "hammer curl",
            aliases: ["db hammer curl", "dumbbell hammer curl"],
            primaryMuscles: [.biceps, .forearms],
            secondaryMuscles: [],
            category: .isolation
        ),
        ExerciseDefinition(
            canonicalName: "tricep pushdown",
            aliases: ["cable pushdown", "tricep cable pushdown", "rope pushdown"],
            primaryMuscles: [.triceps],
            secondaryMuscles: [],
            category: .isolation
        ),
        ExerciseDefinition(
            canonicalName: "skull crusher",
            aliases: ["lying tricep extension", "tricep extension"],
            primaryMuscles: [.triceps],
            secondaryMuscles: [],
            category: .isolation
        ),
        ExerciseDefinition(
            canonicalName: "overhead tricep extension",
            aliases: ["cable overhead extension", "db overhead tricep extension"],
            primaryMuscles: [.triceps],
            secondaryMuscles: [],
            category: .isolation
        ),
        ExerciseDefinition(
            canonicalName: "dip",
            aliases: ["dips", "tricep dip", "chest dip"],
            primaryMuscles: [.triceps, .chest],
            secondaryMuscles: [.shoulders],
            category: .compound
        ),

        // LEGS
        ExerciseDefinition(
            canonicalName: "barbell squat",
            aliases: ["squat", "back squat", "bb squat"],
            primaryMuscles: [.quadriceps, .glutes],
            secondaryMuscles: [.hamstrings, .core],
            category: .compound
        ),
        ExerciseDefinition(
            canonicalName: "front squat",
            aliases: ["barbell front squat"],
            primaryMuscles: [.quadriceps],
            secondaryMuscles: [.glutes, .core],
            category: .compound
        ),
        ExerciseDefinition(
            canonicalName: "leg press",
            aliases: ["machine leg press"],
            primaryMuscles: [.quadriceps],
            secondaryMuscles: [.glutes],
            category: .compound
        ),
        ExerciseDefinition(
            canonicalName: "romanian deadlift",
            aliases: ["rdl", "db rdl", "dumbbell rdl", "barbell rdl", "dumbbell romanian deadlift"],
            primaryMuscles: [.hamstrings, .glutes],
            secondaryMuscles: [.back, .forearms],
            category: .compound
        ),
        ExerciseDefinition(
            canonicalName: "leg extension",
            aliases: ["machine leg extension"],
            primaryMuscles: [.quadriceps],
            secondaryMuscles: [],
            category: .isolation
        ),
        ExerciseDefinition(
            canonicalName: "leg curl",
            aliases: ["hamstring curl", "lying leg curl", "seated leg curl", "machine leg curl"],
            primaryMuscles: [.hamstrings],
            secondaryMuscles: [],
            category: .isolation
        ),
        ExerciseDefinition(
            canonicalName: "lunge",
            aliases: ["walking lunge", "dumbbell lunge", "db lunge", "barbell lunge"],
            primaryMuscles: [.quadriceps, .glutes],
            secondaryMuscles: [.hamstrings, .core],
            category: .compound
        ),
        ExerciseDefinition(
            canonicalName: "hip thrust",
            aliases: ["barbell hip thrust", "glute bridge"],
            primaryMuscles: [.glutes],
            secondaryMuscles: [.hamstrings],
            category: .compound
        ),
        ExerciseDefinition(
            canonicalName: "calf raise",
            aliases: ["standing calf raise", "seated calf raise", "machine calf raise"],
            primaryMuscles: [.calves],
            secondaryMuscles: [],
            category: .isolation
        ),

        // CORE
        ExerciseDefinition(
            canonicalName: "plank",
            aliases: ["front plank"],
            primaryMuscles: [.core],
            secondaryMuscles: [.shoulders],
            category: .isolation
        ),
        ExerciseDefinition(
            canonicalName: "hanging leg raise",
            aliases: ["leg raise", "hanging knee raise"],
            primaryMuscles: [.core],
            secondaryMuscles: [],
            category: .isolation
        ),
        ExerciseDefinition(
            canonicalName: "cable crunch",
            aliases: ["kneeling cable crunch"],
            primaryMuscles: [.core],
            secondaryMuscles: [],
            category: .isolation
        ),

        // TRAPS
        ExerciseDefinition(
            canonicalName: "shrug",
            aliases: ["barbell shrug", "dumbbell shrug", "db shrug", "bb shrug"],
            primaryMuscles: [.traps],
            secondaryMuscles: [.forearms],
            category: .isolation
        ),
    ]

    /// Look up an exercise by name, checking canonical names and aliases.
    static func lookup(_ name: String) -> ExerciseDefinition? {
        let normalized = name.lowercased().trimmingCharacters(in: .whitespaces)

        // Exact match on canonical name
        if let exact = database.first(where: { $0.canonicalName == normalized }) {
            return exact
        }

        // Exact match on alias
        if let aliasMatch = database.first(where: { $0.aliases.contains(normalized) }) {
            return aliasMatch
        }

        // Substring containment: input contains canonical or canonical contains input
        if let substringMatch = database.first(where: {
            normalized.contains($0.canonicalName) || $0.canonicalName.contains(normalized)
        }) {
            return substringMatch
        }

        // Substring on aliases
        if let aliasSubstring = database.first(where: { def in
            def.aliases.contains(where: { alias in
                normalized.contains(alias) || alias.contains(normalized)
            })
        }) {
            return aliasSubstring
        }

        return nil
    }
}
