defmodule FitnessWeb.WorkoutTemplateLive.Show do
  use FitnessWeb, :live_view

  alias Fitness.WorkoutTemplates
  alias Fitness.Accounts
  alias Fitness.WorkoutTemplates.WorkoutItem
  alias Fitness.Exercises
  alias Fitness.WorkoutTemplates.ComplexQuery

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
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

  # update changes

  @impl true
  def handle_event("workout-update", %{"workout_item" => param}, socket) do
    workout_item = WorkoutTemplates.get_workout_item!(param["id"])

    WorkoutTemplates.update_workout_item(workout_item, %{
      "reps" => "#{param["reps"]}",
      "weight" => "#{param["weight"]}"
    })

    {:noreply, socket}
  end

  # Add more set in workout_items

  @impl true
  def handle_event("add-set", param, socket) do
    ComplexQuery.adding_sets(param)
    workout_template_id = param["workout-template-id"]

    socket =
      socket
      |> push_patch(to: "/workout_templates/#{workout_template_id}")

    {:noreply, socket}
  end

  # delete workout item sets and update the set number

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    workout_item_list = socket.assigns.workout_template.workout_items
    ComplexQuery.reorder_workout_items_after_delete(id, workout_item_list)

    socket =
      socket
      |> push_patch(to: "/workout_templates/#{socket.assigns.workout_template.id}")

    {:noreply, socket}
  end

  defp page_title(:show), do: "Show Workout template"
  defp page_title(:edit), do: "Edit Workout template"
end
