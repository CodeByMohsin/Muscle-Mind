defmodule Fitness.Accounts.Services.ChartData do
  alias Fitness.WorkoutTemplates

  def all_complete_workout_chart_data(current_user_id) do
    list_complete_workout_templates =
      Enum.filter(WorkoutTemplates.list_workout_templates(), fn workout_template ->
        workout_template.user_id == current_user_id and workout_template.is_finished == true
      end)

    preload_workout_items_list =
      Enum.map(list_complete_workout_templates, fn each ->
        workout_template = WorkoutTemplates.get_workout_template!(each.id)
        workout_template.workout_items
      end)
      |> List.flatten()

    Enum.reduce(
      preload_workout_items_list,
      %{total_weight: 0, total_sets: 0, total_reps: 0},
      fn each_item, %{total_weight: value, total_sets: value2, total_reps: value3} ->
        %{
          total_weight: value + each_item.weight,
          total_sets: value2 + 1,
          total_reps: value3 + each_item.reps
        }
      end
    )
  end
end
