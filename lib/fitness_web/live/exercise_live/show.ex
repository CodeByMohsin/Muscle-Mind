defmodule FitnessWeb.ExerciseLive.Show do
  use FitnessWeb, :live_view

  alias Fitness.Exercises
  alias Fitness.Accounts

  @impl true
  def mount(_params, session, socket) do
    current_user = Accounts.get_user_by_session_token(session["user_token"])

    if session["user_token"] do
      case current_user do
        nil ->
          {:ok, assign(socket, exercises: Exercises.list_exercises(), search: "")}

        _ ->
          user = current_user
          is_admin = Accounts.is_admin?(user)

          {:ok,
           assign(socket,
             exercises: Exercises.list_exercises(),
             search: "",
             is_admin: is_admin,
             user: user
           )}
      end
    else
      {:ok, socket}
    end
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:exercise, Exercises.get_exercise!(id))}
  end

  defp page_title(:show), do: "Show Exercise"
  defp page_title(:edit), do: "Edit Exercise"
end
