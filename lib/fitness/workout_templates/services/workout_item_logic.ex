defmodule Fitness.WorkoutTemplates.Services.WorkoutItemLogic do
  alias Fitness.WorkoutTemplates

  # calculate single workout template score
  def update_workout_template_score(workout_template) do
    list_of_complete_workout_items =
      Enum.filter(workout_template.workout_items, fn each ->
        each.check_box == true
      end)

    if length(list_of_complete_workout_items) == length(workout_template.workout_items) do
      total_score = Enum.reduce(list_of_complete_workout_items, 0, fn _each, acc -> acc + 20 end)

      WorkoutTemplates.update_workout_template(workout_template, %{
        "workout_template_score" => "#{total_score + 50}",
        "is_finished" => "true"
      })

      true
    else
      total_score = Enum.reduce(list_of_complete_workout_items, 0, fn _each, acc -> acc + 20 end)

      WorkoutTemplates.update_workout_template(workout_template, %{
        "workout_template_score" => "#{total_score}",
        "is_finished" => "true"
      })

      false
    end
  end

  # create a duplicate_workout_template after finished workout
  def duplicate_workout_template(workout_template) do
    {:ok, duplicate_workout_template} =
      WorkoutTemplates.create_workout_template(%{
        "name" => "#{workout_template.name}",
        "user_id" => "#{workout_template.user_id}"
      })

    for workout_item <- workout_template.workout_items do
      WorkoutTemplates.create_workout_item(%{
        "sets" => "#{workout_item.sets}",
        "reps" => "#{workout_item.reps}",
        "weight" => "#{workout_item.weight}",
        "weight_unit" => "#{workout_item.weight_unit}",
        "exercise_id" => "#{workout_item.exercise_id}",
        "workout_template_id" => "#{duplicate_workout_template.id}"
      })
    end
  end

  # filter out completed workout items
  def complete_workout(id, check_box_value) do
    workout_item = WorkoutTemplates.get_workout_item!(id)

    if check_box_value do
      WorkoutTemplates.update_workout_item(workout_item, %{"check_box" => check_box_value})
    else
      WorkoutTemplates.update_workout_item(workout_item, %{"check_box" => check_box_value})
    end

    workout_template = WorkoutTemplates.get_workout_template!(workout_item.workout_template_id)

    Enum.filter(workout_template.workout_items, fn each -> each.check_box == true end)
  end

  # return a list of map have updated values
  def updated_workout_items_list(added_exercise_id, workout_items_list) do
    list_of_filter_same_exercise =
      Enum.filter(workout_items_list, fn each ->
        "#{each.exercise_id}" == added_exercise_id
      end)

    list_of_same_exercise =
      Enum.group_by(list_of_filter_same_exercise, fn each -> each.exercise_id end)
      |> Map.values()

    if list_of_same_exercise == [] do
      [%{sets_number: 1, updated_weight: 0, updated_reps: 12, exercise_id: 0}]
    else
      Enum.map(list_of_same_exercise, fn each_list ->
        workout_item = Enum.at(each_list, -1)

        %{
          sets_number: workout_item.sets + 1,
          updated_weight: workout_item.weight,
          updated_reps: workout_item.reps,
          exercise_id: workout_item.exercise_id
        }
      end)
    end
  end
end
