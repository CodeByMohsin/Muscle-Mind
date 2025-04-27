defmodule Fitness.Accounts.Services.PlayerScores do
  alias Fitness.Accounts
  alias Fitness.WorkoutTemplates

  def update_new_player_score_and_broadcast_score_board(current_user, workout_templates) do
    list_of_workout_template_is_finish_and_is_belong_to_user =
      Enum.filter(workout_templates, fn each ->
        each.is_finished == true and each.user_id == current_user.id
      end)

    total_workout_template_score =
      Enum.reduce(list_of_workout_template_is_finish_and_is_belong_to_user, 0, fn each, acc ->
        acc + each.workout_template_score
      end)

    Accounts.update_user_player_score(current_user, %{
      "player_score" => "#{total_workout_template_score}"
    })

    update_users = Accounts.list_of_users()
    update_workout_template = WorkoutTemplates.list_workout_templates()
    update_user_id = Accounts.get_user!(current_user.id)

    Enum.each(20..update_user_id.player_score, fn each ->
      broadcast_score_board(update_users, update_workout_template, each, current_user.id)
    end)
  end

  defp broadcast_score_board(
         updated_users,
         update_workout_template,
         updated_player_score,
         user_id
       ) do
    Phoenix.PubSub.broadcast(
      Fitness.PubSub,
      "score_board",
      {:update_users, {updated_users, update_workout_template, updated_player_score, user_id}}
    )
  end
end
