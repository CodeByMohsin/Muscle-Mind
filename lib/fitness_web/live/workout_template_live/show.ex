defmodule FitnessWeb.WorkoutTemplateLive.Show do
  use FitnessWeb, :live_view

  alias Fitness.WorkoutTemplates
 alias Fitness.Accounts
  @impl true
  def mount(_params, session, socket) do
    if session["user_token"] do
      user = Accounts.get_user_by_session_token(session["user_token"])
      is_admin = Accounts.is_admin?(user)

      {:ok, assign(socket, is_admin: is_admin, user: user)}
    else
      {:ok, socket}
    end
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:workout_template, WorkoutTemplates.get_workout_template!(id))}
  end

  defp page_title(:show), do: "Show Workout template"
  defp page_title(:edit), do: "Edit Workout template"
end
