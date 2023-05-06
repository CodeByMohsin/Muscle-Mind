defmodule FitnessWeb.ExerciseLive.Index do
  use FitnessWeb, :live_view

  alias Fitness.Exercises
  alias Fitness.Exercises.Exercise
  alias Fitness.Accounts

  @impl true
  def mount(_params, session, socket) do
    if session["user_token"] do
      cond do
        Accounts.get_user_by_session_token(session["user_token"]) == nil ->
          {:ok, assign(socket, exercises: list_exercises(), search: "")}

        Accounts.get_user_by_session_token(session["user_token"]) ->
          user = Accounts.get_user_by_session_token(session["user_token"])
          is_admin = Accounts.is_admin?(user)

          {:ok, assign(socket, exercises: list_exercises(), search: "", is_admin: is_admin, user: user)}
      end
    else
      {:ok, assign(socket, exercises: list_exercises(), search: "")}
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Exercise")
    |> assign(:exercise, Exercises.get_exercise!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Exercise")
    |> assign(:exercise, %Exercise{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Exercises")
    |> assign(:exercise, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    exercise = Exercises.get_exercise!(id)
    {:ok, _} = Exercises.delete_exercise(exercise)

    {:noreply, assign(socket, :exercises, list_exercises())}
  end

  # search by search box

  @impl true
  def handle_event("search", %{"search" => %{"text" => search_query}}, socket) do
    exercises = Exercises.list_exercises(search_query)

    socket =
      socket
      |> assign(search: search_query)
      |> assign(exercises: exercises)

    {:noreply, socket}
  end

  # search by tags

  @impl true
  def handle_event("search", %{"search" => search_query}, socket) do
    exercises = Exercises.list_exercises(search_query)

    socket =
      socket
      |> assign(search: search_query)
      |> assign(exercises: exercises)

    {:noreply, socket}
  end

  defp list_exercises do
    Exercises.list_exercises()
  end
end
