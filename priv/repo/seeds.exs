# Script to generate workout templates from JSON exercise data
# Run with: mix run priv/repo/workout_templates_generator.exs

alias Fitness.Repo
alias Fitness.Accounts
alias Fitness.Exercises.Exercise
alias Fitness.WorkoutTemplates.WorkoutTemplate
alias Fitness.WorkoutTemplates.WorkoutItem

# Create users or get existing ones
{:ok, user1} =
  Accounts.register_user(%{
    email: "test@test9.com",
    password: "mak12345",
    is_admin: false,
    username: "The-Bird-Man",
    name: "marko",
    player_score: "500"
  })

{:ok, user2} =
  Accounts.register_user(%{
    email: "test@test10.com",
    password: "mak12345",
    is_admin: false,
    username: "Elixir-Newbie",
    name: "mohsin",
    player_score: "2000"
  })

# Parse the JSON exercise data
exercise_data = File.read!("priv/repo/exercises.json")
|> Jason.decode!()

# Create all exercises from the JSON data and build a map for easy lookup
exercises_map = %{}
exercises_map = Enum.reduce(exercise_data, exercises_map, fn exercise_json, acc ->
  # Create a unique key for each exercise
  key = exercise_json["name"]
        |> String.downcase()
        |> String.replace(~r/[^a-z0-9]+/, "_")
        |> String.trim("_")

  # Create the exercise in the database
  exercise = Repo.insert!(%Exercise{
    name: exercise_json["name"],
    description: exercise_json["description"],
    gif_url: exercise_json["gif_url"],
    level: String.downcase(exercise_json["level"]),
    type: String.downcase(exercise_json["type"]),
    equipment: String.downcase(exercise_json["equipment"]),
    body_part: String.downcase(exercise_json["body_part"])
  })

  # Add the exercise to our map
  Map.put(acc, key, exercise)
end)

# Helper function to get exercise by name
get_exercise = fn name ->
  key = name
        |> String.downcase()
        |> String.replace(~r/[^a-z0-9]+/, "_")
        |> String.trim("_")
  Map.get(exercises_map, key)
end

# ==================== 1. PUSH/PULL/LEGS SPLIT ====================

# Push Day (Chest, Shoulders, Triceps)
push_template =
  Repo.insert!(%WorkoutTemplate{
    name: "Push Day (Chest, Shoulders, Triceps)",
    user_id: user1.id,
    is_finished: false,
    workout_template_score: 0
  })

# Add exercises to the push day template
Repo.insert!(%WorkoutItem{
  sets: 1,
  weight: 25.0,
  weight_unit: "kg",
  reps: 8,
  check_box: false,
  exercise_id: get_exercise.("dumbbell bench press").id,
  workout_template_id: push_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 2,
  weight: 0.0,
  weight_unit: "kg",
  reps: 12,
  check_box: false,
  exercise_id: get_exercise.("push-up").id,
  workout_template_id: push_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 3,
  weight: 0.0,
  weight_unit: "kg",
  reps: 10,
  check_box: false,
  exercise_id: get_exercise.("chest dip").id,
  workout_template_id: push_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 4,
  weight: 15.0,
  weight_unit: "kg",
  reps: 10,
  check_box: false,
  exercise_id: get_exercise.("band shoulder press").id,
  workout_template_id: push_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 5,
  weight: 8.0,
  weight_unit: "kg",
  reps: 12,
  check_box: false,
  exercise_id: get_exercise.("dumbbell lateral raise").id,
  workout_template_id: push_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 6,
  weight: 0.0,
  weight_unit: "kg",
  reps: 10,
  check_box: false,
  exercise_id: get_exercise.("triceps dip").id,
  workout_template_id: push_template.id
})

# Pull Day (Back and Biceps)
pull_template =
  Repo.insert!(%WorkoutTemplate{
    name: "Pull Day (Back & Biceps)",
    user_id: user1.id,
    is_finished: false,
    workout_template_score: 0
  })

# Add exercises to the pull day template
Repo.insert!(%WorkoutItem{
  sets: 1,
  weight: 0.0,
  weight_unit: "kg",
  reps: 8,
  check_box: false,
  exercise_id: get_exercise.("pull-up").id,
  workout_template_id: pull_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 2,
  weight: 0.0,
  weight_unit: "kg",
  reps: 8,
  check_box: false,
  exercise_id: get_exercise.("chin-up").id,
  workout_template_id: pull_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 3,
  weight: 50.0,
  weight_unit: "kg",
  reps: 10,
  check_box: false,
  exercise_id: get_exercise.("cable seated row").id,
  workout_template_id: pull_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 4,
  weight: 50.0,
  weight_unit: "kg",
  reps: 12,
  check_box: false,
  exercise_id: get_exercise.("barbell shrug").id,
  workout_template_id: pull_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 5,
  weight: 12.0,
  weight_unit: "kg",
  reps: 12,
  check_box: false,
  exercise_id: get_exercise.("dumbbell biceps curl").id,
  workout_template_id: pull_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 6,
  weight: 20.0,
  weight_unit: "kg",
  reps: 10,
  check_box: false,
  exercise_id: get_exercise.("barbell curl").id,
  workout_template_id: pull_template.id
})

# Leg Day
leg_template =
  Repo.insert!(%WorkoutTemplate{
    name: "Leg Day (Quads, Hamstrings, Glutes)",
    user_id: user1.id,
    is_finished: false,
    workout_template_score: 0
  })

# Add exercises to the leg day template
Repo.insert!(%WorkoutItem{
  sets: 1,
  weight: 80.0,
  weight_unit: "kg",
  reps: 8,
  check_box: false,
  exercise_id: get_exercise.("barbell full squat").id,
  workout_template_id: leg_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 2,
  weight: 100.0,
  weight_unit: "kg",
  reps: 6,
  check_box: false,
  exercise_id: get_exercise.("barbell deadlift").id,
  workout_template_id: leg_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 3,
  weight: 20.0,
  weight_unit: "kg",
  reps: 12,
  check_box: false,
  exercise_id: get_exercise.("dumbbell goblet squat").id,
  workout_template_id: leg_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 4,
  weight: 0.0,
  weight_unit: "kg",
  reps: 20,
  check_box: false,
  exercise_id: get_exercise.("walking lunge").id,
  workout_template_id: leg_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 5,
  weight: 60.0,
  weight_unit: "kg",
  reps: 12,
  check_box: false,
  exercise_id: get_exercise.("barbell glute bridge").id,
  workout_template_id: leg_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 6,
  weight: 40.0,
  weight_unit: "kg",
  reps: 15,
  check_box: false,
  exercise_id: get_exercise.("weighted donkey calf raise").id,
  workout_template_id: leg_template.id
})

# ==================== 2. UPPER/LOWER SPLIT ====================

# Upper Body Workout
upper_template =
  Repo.insert!(%WorkoutTemplate{
    name: "Upper Body Day",
    user_id: user2.id,
    is_finished: false,
    workout_template_score: 0
  })

# Add exercises to upper body template
Repo.insert!(%WorkoutItem{
  sets: 1,
  weight: 25.0,
  weight_unit: "kg",
  reps: 8,
  check_box: false,
  exercise_id: get_exercise.("dumbbell bench press").id,
  workout_template_id: upper_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 2,
  weight: 0.0,
  weight_unit: "kg",
  reps: 8,
  check_box: false,
  exercise_id: get_exercise.("pull-up").id,
  workout_template_id: upper_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 3,
  weight: 15.0,
  weight_unit: "kg",
  reps: 10,
  check_box: false,
  exercise_id: get_exercise.("band shoulder press").id,
  workout_template_id: upper_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 4,
  weight: 50.0,
  weight_unit: "kg",
  reps: 10,
  check_box: false,
  exercise_id: get_exercise.("cable seated row").id,
  workout_template_id: upper_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 5,
  weight: 8.0,
  weight_unit: "kg",
  reps: 12,
  check_box: false,
  exercise_id: get_exercise.("dumbbell lateral raise").id,
  workout_template_id: upper_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 6,
  weight: 0.0,
  weight_unit: "kg",
  reps: 10,
  check_box: false,
  exercise_id: get_exercise.("triceps dip").id,
  workout_template_id: upper_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 7,
  weight: 20.0,
  weight_unit: "kg",
  reps: 10,
  check_box: false,
  exercise_id: get_exercise.("barbell curl").id,
  workout_template_id: upper_template.id
})

# Lower Body Workout
lower_template =
  Repo.insert!(%WorkoutTemplate{
    name: "Lower Body Day",
    user_id: user2.id,
    is_finished: false,
    workout_template_score: 0
  })

# Add exercises to lower body template
Repo.insert!(%WorkoutItem{
  sets: 1,
  weight: 80.0,
  weight_unit: "kg",
  reps: 8,
  check_box: false,
  exercise_id: get_exercise.("barbell full squat").id,
  workout_template_id: lower_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 2,
  weight: 100.0,
  weight_unit: "kg",
  reps: 6,
  check_box: false,
  exercise_id: get_exercise.("barbell deadlift").id,
  workout_template_id: lower_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 3,
  weight: 60.0,
  weight_unit: "kg",
  reps: 10,
  check_box: false,
  exercise_id: get_exercise.("barbell front squat").id,
  workout_template_id: lower_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 4,
  weight: 30.0,
  weight_unit: "kg",
  reps: 12,
  check_box: false,
  exercise_id: get_exercise.("barbell step-up").id,
  workout_template_id: lower_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 5,
  weight: 60.0,
  weight_unit: "kg",
  reps: 12,
  check_box: false,
  exercise_id: get_exercise.("barbell glute bridge").id,
  workout_template_id: lower_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 6,
  weight: 40.0,
  weight_unit: "kg",
  reps: 15,
  check_box: false,
  exercise_id: get_exercise.("weighted donkey calf raise").id,
  workout_template_id: lower_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 7,
  weight: 0.0,
  weight_unit: "kg",
  reps: 12,
  check_box: false,
  exercise_id: get_exercise.("hanging leg raise").id,
  workout_template_id: lower_template.id
})

# ==================== 3. FULL BODY WORKOUT ====================

full_body_template =
  Repo.insert!(%WorkoutTemplate{
    name: "Full Body Workout",
    user_id: user1.id,
    is_finished: false,
    workout_template_score: 0
  })

# Add exercises to full body template
Repo.insert!(%WorkoutItem{
  sets: 1,
  weight: 80.0,
  weight_unit: "kg",
  reps: 8,
  check_box: false,
  exercise_id: get_exercise.("barbell full squat").id,
  workout_template_id: full_body_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 2,
  weight: 25.0,
  weight_unit: "kg",
  reps: 8,
  check_box: false,
  exercise_id: get_exercise.("dumbbell bench press").id,
  workout_template_id: full_body_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 3,
  weight: 90.0,
  weight_unit: "kg",
  reps: 6,
  check_box: false,
  exercise_id: get_exercise.("barbell deadlift").id,
  workout_template_id: full_body_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 4,
  weight: 15.0,
  weight_unit: "kg",
  reps: 10,
  check_box: false,
  exercise_id: get_exercise.("band shoulder press").id,
  workout_template_id: full_body_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 5,
  weight: 0.0,
  weight_unit: "kg",
  reps: 8,
  check_box: false,
  exercise_id: get_exercise.("pull-up").id,
  workout_template_id: full_body_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 6,
  weight: 12.0,
  weight_unit: "kg",
  reps: 12,
  check_box: false,
  exercise_id: get_exercise.("dumbbell biceps curl").id,
  workout_template_id: full_body_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 7,
  weight: 0.0,
  weight_unit: "kg",
  reps: 12,
  check_box: false,
  exercise_id: get_exercise.("triceps dip").id,
  workout_template_id: full_body_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 8,
  weight: 0.0,
  weight_unit: "kg",
  reps: 20,
  check_box: false,
  exercise_id: get_exercise.("russian twist").id,
  workout_template_id: full_body_template.id
})

# ==================== 4. BRO SPLIT ====================

# Chest Day
chest_template =
  Repo.insert!(%WorkoutTemplate{
    name: "Chest Day (Bro Split)",
    user_id: user2.id,
    is_finished: false,
    workout_template_score: 0
  })

# Add exercises to chest day template
Repo.insert!(%WorkoutItem{
  sets: 1,
  weight: 25.0,
  weight_unit: "kg",
  reps: 8,
  check_box: false,
  exercise_id: get_exercise.("dumbbell bench press").id,
  workout_template_id: chest_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 2,
  weight: 0.0,
  weight_unit: "kg",
  reps: 12,
  check_box: false,
  exercise_id: get_exercise.("push-up").id,
  workout_template_id: chest_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 3,
  weight: 0.0,
  weight_unit: "kg",
  reps: 10,
  check_box: false,
  exercise_id: get_exercise.("chest dip").id,
  workout_template_id: chest_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 4,
  weight: 0.0,
  weight_unit: "kg",
  reps: 12,
  check_box: false,
  exercise_id: get_exercise.("decline push-up").id,
  workout_template_id: chest_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 5,
  weight: 0.0,
  weight_unit: "kg",
  reps: 12,
  check_box: false,
  exercise_id: get_exercise.("incline push-up").id,
  workout_template_id: chest_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 6,
  weight: 0.0,
  weight_unit: "kg",
  reps: 10,
  check_box: false,
  exercise_id: get_exercise.("suspended push-up").id,
  workout_template_id: chest_template.id
})

# Back Day
back_template =
  Repo.insert!(%WorkoutTemplate{
    name: "Back Day (Bro Split)",
    user_id: user2.id,
    is_finished: false,
    workout_template_score: 0
  })

# Add exercises to back day template
Repo.insert!(%WorkoutItem{
  sets: 1,
  weight: 0.0,
  weight_unit: "kg",
  reps: 8,
  check_box: false,
  exercise_id: get_exercise.("pull-up").id,
  workout_template_id: back_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 2,
  weight: 0.0,
  weight_unit: "kg",
  reps: 8,
  check_box: false,
  exercise_id: get_exercise.("chin-up").id,
  workout_template_id: back_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 3,
  weight: 50.0,
  weight_unit: "kg",
  reps: 10,
  check_box: false,
  exercise_id: get_exercise.("cable seated row").id,
  workout_template_id: back_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 4,
  weight: 0.0,
  weight_unit: "kg",
  reps: 10,
  check_box: false,
  exercise_id: get_exercise.("suspended row").id,
  workout_template_id: back_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 5,
  weight: 50.0,
  weight_unit: "kg",
  reps: 12,
  check_box: false,
  exercise_id: get_exercise.("barbell shrug").id,
  workout_template_id: back_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 6,
  weight: 10.0,
  weight_unit: "kg",
  reps: 12,
  check_box: false,
  exercise_id: get_exercise.("kettlebell alternating renegade row").id,
  workout_template_id: back_template.id
})

# Arms Day
arms_template =
  Repo.insert!(%WorkoutTemplate{
    name: "Arms Day (Bro Split)",
    user_id: user2.id,
    is_finished: false,
    workout_template_score: 0
  })

# Add exercises to arms day template
Repo.insert!(%WorkoutItem{
  sets: 1,
  weight: 20.0,
  weight_unit: "kg",
  reps: 10,
  check_box: false,
  exercise_id: get_exercise.("barbell curl").id,
  workout_template_id: arms_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 2,
  weight: 0.0,
  weight_unit: "kg",
  reps: 10,
  check_box: false,
  exercise_id: get_exercise.("triceps dip").id,
  workout_template_id: arms_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 3,
  weight: 12.0,
  weight_unit: "kg",
  reps: 12,
  check_box: false,
  exercise_id: get_exercise.("dumbbell biceps curl").id,
  workout_template_id: arms_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 4,
  weight: 0.0,
  weight_unit: "kg",
  reps: 12,
  check_box: false,
  exercise_id: get_exercise.("weighted bench dip").id,
  workout_template_id: arms_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 5,
  weight: 12.0,
  weight_unit: "kg",
  reps: 12,
  check_box: false,
  exercise_id: get_exercise.("dumbbell preacher curl").id,
  workout_template_id: arms_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 6,
  weight: 0.0,
  weight_unit: "kg",
  reps: 15,
  check_box: false,
  exercise_id: get_exercise.("diamond push-up").id,
  workout_template_id: arms_template.id
})

# ==================== 5. FUNCTIONAL FITNESS WORKOUT ====================

functional_template =
  Repo.insert!(%WorkoutTemplate{
    name: "Functional Fitness Workout",
    user_id: user1.id,
    is_finished: false,
    workout_template_score: 0
  })

# Add exercises to functional fitness template
Repo.insert!(%WorkoutItem{
  sets: 1,
  weight: 16.0,
  weight_unit: "kg",
  reps: 20,
  check_box: false,
  exercise_id: get_exercise.("kettlebell swing").id,
  workout_template_id: functional_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 2,
  weight: 0.0,
  weight_unit: "kg",
  reps: 15,
  check_box: false,
  exercise_id: get_exercise.("burpee").id,
  workout_template_id: functional_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 3,
  weight: 80.0,
  weight_unit: "kg",
  reps: 6,
  check_box: false,
  exercise_id: get_exercise.("power clean").id,
  workout_template_id: functional_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 4,
  weight: 60.0,
  weight_unit: "kg",
  reps: 8,
  check_box: false,
  exercise_id: get_exercise.("barbell thruster").id,
  workout_template_id: functional_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 5,
  weight: 0.0,
  weight_unit: "kg",
  reps: 20,
  check_box: false,
  exercise_id: get_exercise.("mountain climber").id,
  workout_template_id: functional_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 6,
  weight: 0.0,
  weight_unit: "kg",
  reps: 12,
  check_box: false,
  exercise_id: get_exercise.("bear crawl").id,
  workout_template_id: functional_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 7,
  weight: 0.0,
  weight_unit: "kg",
  reps: 10,
  check_box: false,
  exercise_id: get_exercise.("jump squat").id,
  workout_template_id: functional_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 8,
  weight: 10.0,
  weight_unit: "kg",
  reps: 6,
  check_box: false,
  exercise_id: get_exercise.("kettlebell thruster").id,
  workout_template_id: functional_template.id
})

IO.puts("Successfully created 5 workout templates with all exercises from the provided JSON data")
