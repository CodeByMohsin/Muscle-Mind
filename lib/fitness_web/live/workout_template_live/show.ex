defmodule FitnessWeb.WorkoutTemplateLive.Show do
  use FitnessWeb, :live_view

  alias Fitness.WorkoutTemplates
  alias Fitness.Accounts
  alias Fitness.WorkoutTemplates.WorkoutItem
  alias Fitness.Exercises
  alias FitnessWeb.WorkoutTemplateLive.WorkoutItemCreatedForm 

  @impl true
  def mount(_params, session, socket) do
    if session["user_token"] do
      cond do
        Accounts.get_user_by_session_token(session["user_token"]) == nil ->
          {:ok, socket}

        Accounts.get_user_by_session_token(session["user_token"]) ->
          user = Accounts.get_user_by_session_token(session["user_token"])
          is_admin = Accounts.is_admin?(user)

          {:ok, assign(socket, is_admin: is_admin, user: user)}
      end
    else
      {:ok, socket}
    end
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    changeset = WorkoutTemplates.change_workout_item(%WorkoutItem{})
    exercises = Exercises.list_exercises()

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:workout_template, WorkoutTemplates.get_workout_template!(id))
     |> assign(:changeset, changeset)
     |> assign(:exercises, exercises)}
  end



  defp page_title(:show), do: "Show Workout template"
  defp page_title(:edit), do: "Edit Workout template"
end
