# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Fitness.Repo.insert!(%Fitness.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Fitness.Exercises
alias Fitness.Accounts
alias Fitness.Repo
alias Fitness.Exercises.Exercise
alias Fitness.WorkoutTemplates.WorkoutTemplate
alias Fitness.WorkoutTemplates.WorkoutItem

File.read!("priv/repo/list_of_exercises.txt")
|> :erlang.binary_to_term()
|> Enum.uniq()
|> Enum.each(fn workout -> Exercises.create_exercise(workout) end)

Accounts.register_user(%{
  email: "test@test.com",
  password: "test@test.com",
  is_admin: true,
  username: "Admin001",
  name: "Admin"
})

Accounts.register_user(%{
  email: "test@test1.com",
  password: "mak12345",
  is_admin: false,
  username: "puppies-lover",
  name: "Andervrs",
  player_score: "1001"
})

Accounts.register_user(%{
  email: "test@test2.com",
  password: "mak12345",
  is_admin: false,
  username: "Full-stack-developer",
  name: "Alfred",
  player_score: "800"
})

Accounts.register_user(%{
  email: "test@test3.com",
  password: "mak12345",
  is_admin: false,
  username: "Captain-America",
  name: "john",
  player_score: "1000"
})

Accounts.register_user(%{
  email: "test@test4.com",
  password: "mak12345",
  is_admin: false,
  username: "Rhythm-Rider",
  name: "Einer",
  player_score: "700"
})

Accounts.register_user(%{
  email: "test@test5.com",
  password: "mak12345",
  is_admin: false,
  username: "Richie-Rich",
  name: "yusef",
  player_score: "900"
})

Accounts.register_user(%{
  email: "test@test6.com",
  password: "mak12345",
  is_admin: false,
  username: "The-Label-Man",
  name: "eddie",
  player_score: "10000"
})

Accounts.register_user(%{
  email: "test@test7.com",
  password: "mak12345",
  is_admin: false,
  username: "The-Wizard",
  name: "brook",
  player_score: "5000"
})

Accounts.register_user(%{
  email: "test@test8.com",
  password: "mak12345",
  is_admin: false,
  username: "Albert-Einstein",
  name: "steve",
  player_score: "600"
})

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

# Create exercises
exercises = %{
  # Chest exercises
  "bench_press" =>
    Repo.insert!(%Exercise{
      name: "Barbell Bench Press",
      description: "A compound exercise that targets the chest, shoulders, and triceps",
      gif_url: "https://example.com/bench-press.gif",
      level: "beginner",
      type: "strength",
      equipment: "barbell",
      body_part: "chest"
    }),
  "incline_press" =>
    Repo.insert!(%Exercise{
      name: "Incline Dumbbell Press",
      description: "Targets the upper chest with an angled press",
      gif_url: "https://example.com/incline-press.gif",
      level: "beginner",
      type: "strength",
      equipment: "dumbbell",
      body_part: "chest"
    }),
  "chest_fly" =>
    Repo.insert!(%Exercise{
      name: "Dumbbell Chest Fly",
      description: "An isolation exercise for the chest",
      gif_url: "https://example.com/chest-fly.gif",
      level: "intermediate",
      type: "isolation",
      equipment: "dumbbell",
      body_part: "chest"
    }),

  # Back exercises
  "pull_up" =>
    Repo.insert!(%Exercise{
      name: "Pull-up",
      description: "A compound exercise that targets the back and biceps",
      gif_url: "https://example.com/pullup.gif",
      level: "intermediate",
      type: "strength",
      equipment: "bodyweight",
      body_part: "back"
    }),
  "bent_row" =>
    Repo.insert!(%Exercise{
      name: "Bent Over Row",
      description: "A compound pulling exercise for back thickness",
      gif_url: "https://example.com/bent-row.gif",
      level: "beginner",
      type: "strength",
      equipment: "barbell",
      body_part: "back"
    }),
  "lat_pulldown" =>
    Repo.insert!(%Exercise{
      name: "Lat Pulldown",
      description: "A machine exercise targeting the latissimus dorsi",
      gif_url: "https://example.com/lat-pulldown.gif",
      level: "beginner",
      type: "strength",
      equipment: "cable",
      body_part: "back"
    }),
  "face_pull" =>
    Repo.insert!(%Exercise{
      name: "Face Pull",
      description: "An exercise that targets the rear deltoids and upper back",
      gif_url: "https://example.com/face-pull.gif",
      level: "beginner",
      type: "isolation",
      equipment: "cable",
      body_part: "back"
    }),

  # Shoulder exercises
  "overhead_press" =>
    Repo.insert!(%Exercise{
      name: "Overhead Press",
      description: "A compound exercise for the shoulders and triceps",
      gif_url: "https://example.com/overhead-press.gif",
      level: "intermediate",
      type: "strength",
      equipment: "barbell",
      body_part: "shoulders"
    }),
  "lateral_raise" =>
    Repo.insert!(%Exercise{
      name: "Lateral Raise",
      description: "An isolation exercise for the lateral deltoids",
      gif_url: "https://example.com/lateral-raise.gif",
      level: "beginner",
      type: "isolation",
      equipment: "dumbbell",
      body_part: "shoulders"
    }),

  # Arms exercises
  "bicep_curl" =>
    Repo.insert!(%Exercise{
      name: "Bicep Curl",
      description: "An isolation exercise for the biceps",
      gif_url: "https://example.com/bicep-curl.gif",
      level: "beginner",
      type: "isolation",
      equipment: "dumbbell",
      body_part: "arms"
    }),
  "hammer_curl" =>
    Repo.insert!(%Exercise{
      name: "Hammer Curl",
      description: "Targets the brachialis and brachioradialis muscles",
      gif_url: "https://example.com/hammer-curl.gif",
      level: "beginner",
      type: "isolation",
      equipment: "dumbbell",
      body_part: "arms"
    }),
  "tricep_extension" =>
    Repo.insert!(%Exercise{
      name: "Tricep Extension",
      description: "An isolation exercise for the triceps",
      gif_url: "https://example.com/tricep-extension.gif",
      level: "beginner",
      type: "isolation",
      equipment: "cable",
      body_part: "arms"
    }),
  "skull_crusher" =>
    Repo.insert!(%Exercise{
      name: "Skull Crusher",
      description: "A lying tricep extension exercise",
      gif_url: "https://example.com/skull-crusher.gif",
      level: "intermediate",
      type: "isolation",
      equipment: "barbell",
      body_part: "arms"
    }),

  # Leg exercises
  "squat" =>
    Repo.insert!(%Exercise{
      name: "Squat",
      description: "A compound exercise that targets the quadriceps, hamstrings, and glutes",
      gif_url: "https://example.com/squat.gif",
      level: "beginner",
      type: "strength",
      equipment: "barbell",
      body_part: "legs"
    }),
  "deadlift" =>
    Repo.insert!(%Exercise{
      name: "Deadlift",
      description: "A compound exercise that targets the back, glutes, and hamstrings",
      gif_url: "https://example.com/deadlift.gif",
      level: "intermediate",
      type: "strength",
      equipment: "barbell",
      body_part: "legs"
    }),
  "leg_press" =>
    Repo.insert!(%Exercise{
      name: "Leg Press",
      description: "A machine compound exercise for the lower body",
      gif_url: "https://example.com/leg-press.gif",
      level: "beginner",
      type: "strength",
      equipment: "machine",
      body_part: "legs"
    }),
  "romanian_deadlift" =>
    Repo.insert!(%Exercise{
      name: "Romanian Deadlift",
      description: "A hip-hinge movement targeting the hamstrings and glutes",
      gif_url: "https://example.com/romanian-deadlift.gif",
      level: "intermediate",
      type: "strength",
      equipment: "barbell",
      body_part: "legs"
    }),
  "leg_curl" =>
    Repo.insert!(%Exercise{
      name: "Leg Curl",
      description: "An isolation exercise for the hamstrings",
      gif_url: "https://example.com/leg-curl.gif",
      level: "beginner",
      type: "isolation",
      equipment: "machine",
      body_part: "legs"
    }),
  "calf_raise" =>
    Repo.insert!(%Exercise{
      name: "Calf Raise",
      description: "An isolation exercise for the calves",
      gif_url: "https://example.com/calf-raise.gif",
      level: "beginner",
      type: "isolation",
      equipment: "machine",
      body_part: "legs"
    }),

  # Core exercises
  "ab_crunch" =>
    Repo.insert!(%Exercise{
      name: "Ab Crunch",
      description: "A basic abdominal exercise",
      gif_url: "https://example.com/ab-crunch.gif",
      level: "beginner",
      type: "isolation",
      equipment: "bodyweight",
      body_part: "core"
    }),
  "leg_raise" =>
    Repo.insert!(%Exercise{
      name: "Hanging Leg Raise",
      description: "An advanced core exercise",
      gif_url: "https://example.com/hanging-leg-raise.gif",
      level: "advanced",
      type: "isolation",
      equipment: "bodyweight",
      body_part: "core"
    })
}

# ==================== PUSH/PULL/LEGS SPLIT ====================

# Push Day (Chest, Shoulders, Triceps)
push_template =
  Repo.insert!(%WorkoutTemplate{
    name: "Push Day",
    user_id: user1.id,
    is_finished: false,
    workout_template_score: 0
  })

Repo.insert!(%WorkoutItem{
  sets: 4,
  weight: 80.0,
  weight_unit: "kg",
  reps: 8,
  check_box: false,
  exercise_id: exercises["bench_press"].id,
  workout_template_id: push_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 3,
  weight: 20.0,
  weight_unit: "kg",
  reps: 10,
  check_box: false,
  exercise_id: exercises["incline_press"].id,
  workout_template_id: push_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 3,
  weight: 12.0,
  weight_unit: "kg",
  reps: 12,
  check_box: false,
  exercise_id: exercises["chest_fly"].id,
  workout_template_id: push_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 4,
  weight: 40.0,
  weight_unit: "kg",
  reps: 8,
  check_box: false,
  exercise_id: exercises["overhead_press"].id,
  workout_template_id: push_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 3,
  weight: 10.0,
  weight_unit: "kg",
  reps: 12,
  check_box: false,
  exercise_id: exercises["lateral_raise"].id,
  workout_template_id: push_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 3,
  weight: 25.0,
  weight_unit: "kg",
  reps: 10,
  check_box: false,
  exercise_id: exercises["skull_crusher"].id,
  workout_template_id: push_template.id
})

# Pull Day (Back, Biceps)
pull_template =
  Repo.insert!(%WorkoutTemplate{
    name: "Pull Day",
    user_id: user1.id,
    is_finished: false,
    workout_template_score: 0
  })

Repo.insert!(%WorkoutItem{
  sets: 4,
  # Bodyweight
  weight: 0.0,
  weight_unit: "kg",
  reps: 8,
  check_box: false,
  exercise_id: exercises["pull_up"].id,
  workout_template_id: pull_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 4,
  weight: 60.0,
  weight_unit: "kg",
  reps: 10,
  check_box: false,
  exercise_id: exercises["bent_row"].id,
  workout_template_id: pull_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 3,
  weight: 50.0,
  weight_unit: "kg",
  reps: 12,
  check_box: false,
  exercise_id: exercises["lat_pulldown"].id,
  workout_template_id: pull_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 3,
  weight: 20.0,
  weight_unit: "kg",
  reps: 15,
  check_box: false,
  exercise_id: exercises["face_pull"].id,
  workout_template_id: pull_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 3,
  weight: 15.0,
  weight_unit: "kg",
  reps: 10,
  check_box: false,
  exercise_id: exercises["bicep_curl"].id,
  workout_template_id: pull_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 3,
  weight: 15.0,
  weight_unit: "kg",
  reps: 10,
  check_box: false,
  exercise_id: exercises["hammer_curl"].id,
  workout_template_id: pull_template.id
})

# Leg Day
leg_template =
  Repo.insert!(%WorkoutTemplate{
    name: "Leg Day",
    user_id: user1.id,
    is_finished: false,
    workout_template_score: 0
  })

Repo.insert!(%WorkoutItem{
  sets: 4,
  weight: 100.0,
  weight_unit: "kg",
  reps: 8,
  check_box: false,
  exercise_id: exercises["squat"].id,
  workout_template_id: leg_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 3,
  weight: 120.0,
  weight_unit: "kg",
  reps: 10,
  check_box: false,
  exercise_id: exercises["leg_press"].id,
  workout_template_id: leg_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 3,
  weight: 80.0,
  weight_unit: "kg",
  reps: 10,
  check_box: false,
  exercise_id: exercises["romanian_deadlift"].id,
  workout_template_id: leg_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 3,
  weight: 40.0,
  weight_unit: "kg",
  reps: 12,
  check_box: false,
  exercise_id: exercises["leg_curl"].id,
  workout_template_id: leg_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 4,
  weight: 100.0,
  weight_unit: "kg",
  reps: 15,
  check_box: false,
  exercise_id: exercises["calf_raise"].id,
  workout_template_id: leg_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 3,
  # Bodyweight
  weight: 0.0,
  weight_unit: "kg",
  reps: 15,
  check_box: false,
  exercise_id: exercises["ab_crunch"].id,
  workout_template_id: leg_template.id
})

# ==================== UPPER/LOWER SPLIT ====================

# Upper Body Day
upper_template =
  Repo.insert!(%WorkoutTemplate{
    name: "Upper Body Day",
    user_id: user2.id,
    is_finished: false,
    workout_template_score: 0
  })

Repo.insert!(%WorkoutItem{
  sets: 4,
  weight: 75.0,
  weight_unit: "kg",
  reps: 8,
  check_box: false,
  exercise_id: exercises["bench_press"].id,
  workout_template_id: upper_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 4,
  weight: 70.0,
  weight_unit: "kg",
  reps: 8,
  check_box: false,
  exercise_id: exercises["bent_row"].id,
  workout_template_id: upper_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 3,
  weight: 45.0,
  weight_unit: "kg",
  reps: 10,
  check_box: false,
  exercise_id: exercises["overhead_press"].id,
  workout_template_id: upper_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 3,
  weight: 60.0,
  weight_unit: "kg",
  reps: 10,
  check_box: false,
  exercise_id: exercises["lat_pulldown"].id,
  workout_template_id: upper_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 3,
  weight: 15.0,
  weight_unit: "kg",
  reps: 12,
  check_box: false,
  exercise_id: exercises["bicep_curl"].id,
  workout_template_id: upper_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 3,
  weight: 25.0,
  weight_unit: "kg",
  reps: 12,
  check_box: false,
  exercise_id: exercises["tricep_extension"].id,
  workout_template_id: upper_template.id
})

# Lower Body Day
lower_template =
  Repo.insert!(%WorkoutTemplate{
    name: "Lower Body Day",
    user_id: user2.id,
    is_finished: false,
    workout_template_score: 0
  })

Repo.insert!(%WorkoutItem{
  sets: 4,
  weight: 110.0,
  weight_unit: "kg",
  reps: 8,
  check_box: false,
  exercise_id: exercises["squat"].id,
  workout_template_id: lower_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 4,
  weight: 130.0,
  weight_unit: "kg",
  reps: 6,
  check_box: false,
  exercise_id: exercises["deadlift"].id,
  workout_template_id: lower_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 3,
  weight: 140.0,
  weight_unit: "kg",
  reps: 12,
  check_box: false,
  exercise_id: exercises["leg_press"].id,
  workout_template_id: lower_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 3,
  weight: 50.0,
  weight_unit: "kg",
  reps: 12,
  check_box: false,
  exercise_id: exercises["leg_curl"].id,
  workout_template_id: lower_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 4,
  weight: 80.0,
  weight_unit: "kg",
  reps: 15,
  check_box: false,
  exercise_id: exercises["calf_raise"].id,
  workout_template_id: lower_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 3,
  weight: 0.0,
  weight_unit: "kg",
  reps: 15,
  check_box: false,
  exercise_id: exercises["leg_raise"].id,
  workout_template_id: lower_template.id
})

# ==================== BRO SPLIT ====================

# Chest Day
chest_template =
  Repo.insert!(%WorkoutTemplate{
    name: "Chest Day",
    user_id: user2.id,
    is_finished: false,
    workout_template_score: 0
  })

Repo.insert!(%WorkoutItem{
  sets: 4,
  weight: 85.0,
  weight_unit: "kg",
  reps: 8,
  check_box: false,
  exercise_id: exercises["bench_press"].id,
  workout_template_id: chest_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 4,
  weight: 25.0,
  weight_unit: "kg",
  reps: 10,
  check_box: false,
  exercise_id: exercises["incline_press"].id,
  workout_template_id: chest_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 3,
  weight: 15.0,
  weight_unit: "kg",
  reps: 12,
  check_box: false,
  exercise_id: exercises["chest_fly"].id,
  workout_template_id: chest_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 3,
  weight: 25.0,
  weight_unit: "kg",
  reps: 12,
  check_box: false,
  exercise_id: exercises["tricep_extension"].id,
  workout_template_id: chest_template.id
})

# Back Day
back_template =
  Repo.insert!(%WorkoutTemplate{
    name: "Back Day",
    user_id: user2.id,
    is_finished: false,
    workout_template_score: 0
  })

Repo.insert!(%WorkoutItem{
  sets: 4,
  # Bodyweight
  weight: 0.0,
  weight_unit: "kg",
  reps: 8,
  check_box: false,
  exercise_id: exercises["pull_up"].id,
  workout_template_id: back_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 4,
  weight: 65.0,
  weight_unit: "kg",
  reps: 10,
  check_box: false,
  exercise_id: exercises["bent_row"].id,
  workout_template_id: back_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 3,
  weight: 55.0,
  weight_unit: "kg",
  reps: 12,
  check_box: false,
  exercise_id: exercises["lat_pulldown"].id,
  workout_template_id: back_template.id
})

Repo.insert!(%WorkoutItem{
  sets: 3,
  weight: 15.0,
  weight_unit: "kg",
  reps: 12,
  check_box: false,
  exercise_id: exercises["bicep_curl"].id,
  workout_template_id: back_template.id
})

IO.puts("Database seeded successfully with popular workout splits!")
