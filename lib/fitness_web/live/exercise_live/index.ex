defmodule FitnessWeb.ExerciseLive.Index do
  use FitnessWeb, :live_view

  alias Fitness.Exercises
  alias Fitness.Exercises.Exercise

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, exercises: list_exercises(), search: "")}
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

  @impl true
  def handle_event("search", %{"search" => %{"text" => search_query}}, socket) do

    exercises = Exercises.list_exercises()

    socket =
      socket
      |> assign(search: search_query)
      |> assign(exercises: filter_by_search(exercises, search_query))

    {:noreply, socket}
  end



  defp filter_by_search(exercises, search_query) do


    found_search_query =
      case search_query do
        "" ->
          exercises

        search_query ->
          words = search_query |> String.downcase() |> String.split()

          exercises
          |> Enum.filter(fn exercise ->
            texts =
              [
                exercise.name |> String.downcase(),
                exercise.level |> String.downcase(),
                exercise.type |> String.downcase(),
                exercise.body_part |> String.downcase(),
                exercise.equipment |> String.downcase()
              ]
              |> Enum.join()

            Enum.all?(words, fn word ->
              String.contains?(texts, word)
            end)
          end)
      end

    found_search_query
  end

  defp list_exercises do
    Exercises.list_exercises()
  end
end
