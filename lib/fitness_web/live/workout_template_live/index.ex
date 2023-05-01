defmodule FitnessWeb.WorkoutTemplateLive.Index do
  use FitnessWeb, :live_view

  alias Fitness.WorkoutTemplates
  alias Fitness.WorkoutTemplates.WorkoutTemplate
  alias Fitness.Accounts

  @impl true
  def mount(_params, session, socket) do
    if session["user_token"] do
      cond do
        Accounts.get_user_by_session_token(session["user_token"]) == nil ->
          {:ok, assign(socket, workout_templates: list_workout_templates())}

        Accounts.get_user_by_session_token(session["user_token"]) ->
          user = Accounts.get_user_by_session_token(session["user_token"])
          is_admin = Accounts.is_admin?(user)

          {:ok, assign(socket, workout_templates: list_workout_templates(), is_admin: is_admin, user: user)}
      end
    else
      {:ok, assign(socket, workout_templates: list_workout_templates())}
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Workout template")
    |> assign(:workout_template, WorkoutTemplates.get_workout_template!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Workout template")
    |> assign(:workout_template, %WorkoutTemplate{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Workout templates")
    |> assign(:workout_template, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    workout_template = WorkoutTemplates.get_workout_template!(id)
    {:ok, _} = WorkoutTemplates.delete_workout_template(workout_template)

    {:noreply, assign(socket, :workout_templates, list_workout_templates())}
  end

  defp list_workout_templates do
    WorkoutTemplates.list_workout_templates()
  end
end
