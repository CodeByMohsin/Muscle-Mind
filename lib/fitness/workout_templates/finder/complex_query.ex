defmodule Fitness.WorkoutTemplates.ComplexQuery do
  alias Fitness.WorkoutTemplates

  def adding_sets(param) do
    exercise_id = param["exercise-id"]
    workout_template_id = param["workout-template-id"]
    weight_unit = param["weight-unit"]

    WorkoutTemplates.create_workout_item(
      Map.put(%{}, "sets", "#{String.to_integer(param["sets"]) + 1}")
      |> Map.put("exercise_id", exercise_id)
      |> Map.put("workout_template_id", workout_template_id)
      |> Map.put("weight_unit", weight_unit)
      |> Map.put("reps", param["reps"])
      |> Map.put("weight", param["weight"])
    )
  end

  def reorder_workout_items_after_delete(id, workout_item_list) do
    workout_item = WorkoutTemplates.get_workout_item!(id)

    {:ok, list_of_workout_items_after_delete} = WorkoutTemplates.delete_workout_item(workout_item)

    list_of_filter_same_exercise =
      Enum.filter(workout_item_list, fn each ->
        each.exercise_id == list_of_workout_items_after_delete.exercise_id
      end)

    list_of_same_exercise =
      Enum.group_by(list_of_filter_same_exercise, fn each -> each.exercise_id end)
      |> Map.values()

    Enum.map(list_of_same_exercise, fn each ->
      order_change_list =
        Enum.filter(each, fn workout_item ->
          workout_item.sets > list_of_workout_items_after_delete.sets
        end)

      if order_change_list != [] do
        Enum.each(order_change_list, fn each ->
          WorkoutTemplates.update_workout_item(each, %{"sets" => "#{each.sets - 1}"})
        end)
      end
    end)
  end
end
