defmodule FitnessWeb.WorkoutTemplateLive.WorkoutItemForm do
  use FitnessWeb, :live_component

  alias Fitness.WorkoutTemplates
  alias Fitness.WorkoutTemplates.WorkoutItem
  alias Fitness.Exercises
  alias Fitness.WorkoutTemplates.Services.WorkoutItemLogic

  @impl true
  def update(assigns, socket) do
    changeset = WorkoutTemplates.change_workout_item(assigns[:workout_item] || %WorkoutItem{})
    exercises = Exercises.list_exercises()

    socket =
      socket
      |> assign(assigns)
      |> assign(:exercises, exercises)
      |> assign(:sets_number, 1)
      |> assign(:current_weight, 0)
      |> assign(:exercise_id, 0)
      |> assign(:current_reps, 12)
      |> assign(:changeset, changeset)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""


    <div class="p-8 bg-white rounded-lg">
    <h2 class="flex items-center justify-center pt-0 mb-4 text-3xl font-poppins">Add New Exercises</h2>

      <.form
        let={f}
        for={@changeset}
        id="new-workout-item"
        phx-target={@myself}
        phx-change="updated_workout-item"
        phx-submit="add_new_exercise">


        <div class="grid grid-cols-1 gap-2">
          <div>
            <label for="exercise_id" class="block mb-2 text-sm font-medium text-gray-700 font-poppins">Choose an exercise:</label>
            <%= select f, :exercise_id, Enum.map(@exercises, fn exercise -> {exercise.name, exercise.id} end), value: @exercise_id, prompt: "Select an exercise", class: "form-select font-poppins block w-full rounded-md shadow-sm py-2 px-3 text-gray-700 bg-white focus:outline-none focus:ring focus:ring-blue-200 focus:border-blue-500 sm:text-sm" %>
            <%= error_tag f, :exercise_id %>
          </div>

          <div class="grid grid-cols-3 gap-2">
          <div>
            <label for="sets" class="block mb-2 text-sm font-medium text-gray-700 font-poppins">Number of sets:</label>
            <%= number_input f, :sets, value: @sets_number, disabled: true, class: "form-input font-poppins rounded-md shadow-sm mt-1 block w-full" %>
            <%= error_tag f, :sets %>
          </div>

          <div>
            <label for="reps" class="block mb-2 text-sm font-medium text-gray-700 font-poppins">Number of reps:</label>
            <%= number_input f, :reps, value: @current_reps, disabled: false, class: "form-input font-poppins rounded-md shadow-sm mt-1 block w-full" %>
            <%= error_tag f, :reps %>
          </div>

          <div>
            <label for="weight" class="block mb-2 text-sm font-medium text-gray-700 font-poppins">Weight:</label>
            <div class="flex">
              <%= number_input f, :weight, value: @current_weight,  step: "any", class: "form-input font-poppins rounded-md shadow-sm mt-1 block w-full" %>
              <%= error_tag f, :weight %>
              <%= select f, :weight_unit, ["kg", "lbs"], class: "form-select ml-2 rounded-md shadow-sm py-0 px-6 font-poppins text-gray-700 bg-white focus:outline-none focus:ring focus:ring-blue-200 focus:border-blue-500 sm:text-sm" %>
            </div>
            </div>
          </div>
        </div>

        <div class="flex justify-center mt-6">
          <%= submit "ADD EXERCISE", phx_disable_with: "Adding...", class: "bg-green-400 hover:bg-green-600 text-white font-poppins py-2 px-4 rounded" %>
        </div>
      </.form>
    </div>
    """
  end

  @impl true
  def handle_event("updated_workout-item", %{"workout_item" => param}, socket) do
    current_exercise_id = param["exercise_id"]
    workout_items_list = socket.assigns.workout_template.workout_items

    [current | _tail] =
      WorkoutItemLogic.updated_workout_items_list(current_exercise_id, workout_items_list)

    {:noreply,
     assign(socket,
       sets_number: current.sets_number,
       current_reps: current.updated_reps,
       current_weight: current.updated_weight,
       exercise_id: current.exercise_id
     )}
  end

  @impl true
  def handle_event("add_new_exercise", %{"workout_item" => param}, socket) do
    workout_template_id = socket.assigns.workout_template.id

    case WorkoutTemplates.create_workout_item(
           Map.put(param, "workout_template_id", workout_template_id)
           |> Map.put("sets", socket.assigns.sets_number)
         ) do
      {:ok, workout_item} ->
        socket =
          socket
          |> push_redirect(to: "/workout_templates/#{workout_item.workout_template_id}")

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
