query GetWorkoutTemplateFast {
    getWorkoutTemplate(input: { workoutTemplateId: 2 }) {
        workoutItemsFast {
            id
            reps
            sets
            weight
            weightUnit
            exerciseFast {
                bodyPart
                description
                equipment
                id
                level
                name
                type
            }
        }
    }
}


query GetWorkoutTemplateSlow {
    getWorkoutTemplate(input: { workoutTemplateId: 2 }) {
        workoutItemsSlow {
            id
            reps
            sets
            weight
            weightUnit
            exerciseSlow {
                bodyPart
                description
                equipment
                id
                level
                name
                type
            }
        }
    }
}





query WorkoutTemplates {
    workoutTemplates {
        id
        isFinished
        name
        workoutTemplateScore
        workoutItemsFast {
            id
            reps
            sets
            weight
            weightUnit
            exerciseFast {
                bodyPart
                description
                equipment
                id
                level
                name
                type
            }
        }
    }
}



query WorkoutTemplates {
    workoutTemplates {
        id
        isFinished
        name
        workoutTemplateScore
        workoutItemsSlow {
            id
            reps
            sets
            weight
            weightUnit
            exerciseFast {
                bodyPart
                description
                equipment
                id
                level
                name
                type
            }
        }
    }
}
