defmodule FitnessWeb.WorkoutTemplateLive.WorkoutItemCreatedForm do
  use FitnessWeb, :live_component

  alias Fitness.WorkoutTemplates
  alias Fitness.WorkoutTemplates.WorkoutItem
  alias Fitness.Exercises

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
      |> assign(:changeset, changeset)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""

    <div class="bg-white shadow-lg rounded-lg p-8">
      <.form
        let={f}
        for={@changeset}
        id="created-workout-item"
        phx-target={@myself}
        phx-change="workout-item"
        phx-submit="update">

        <div class="grid grid-cols-1 gap-2">
          <div>
            <label for="exercise_id" class="block text-sm font-poppins font-medium text-gray-700 mb-2">Choose an exercise:</label>
            <%= select f, :exercise_id, Enum.map(@exercises, fn exercise -> {exercise.name, exercise.id} end),  prompt: "Select an exercise", class: "form-select font-poppins block w-full rounded-md shadow-sm py-2 px-3 text-gray-700 bg-white focus:outline-none focus:ring focus:ring-blue-200 focus:border-blue-500 sm:text-sm" %>
            <%= error_tag f, :exercise_id %>
          </div>

          <div class="grid grid-cols-3 gap-2">
          <div>
            <label for="sets" class="block text-sm font-medium font-poppins text-gray-700 mb-2">Number of sets:</label>
            <%= number_input f, :sets, disabled: false, class: "form-input font-poppins rounded-md shadow-sm mt-1 block w-full" %>
            <%= error_tag f, :sets %>
          </div>

          <div>
            <label for="reps" class="block text-sm font-medium font-poppins text-gray-700 mb-2">Number of reps:</label>
            <%= number_input f, :reps, disabled: false, class: "form-input font-poppins rounded-md shadow-sm mt-1 block w-full" %>
            <%= error_tag f, :reps %>
          </div>

          <div>
            <label for="weight" class="block text-sm font-medium font-poppins text-gray-700 mb-2">Weight:</label>
            <div class="flex">
              <%= number_input f, :weight,  step: "any", class: "form-input font-poppins rounded-md shadow-sm mt-1 block w-full" %>
              <%= error_tag f, :weight %>
              <%= select f, :weight_unit, ["kg", "lbs"], class: "form-select ml-2 rounded-md shadow-sm py-0 px-6 font-poppins text-gray-700 bg-white focus:outline-none focus:ring focus:ring-blue-200 focus:border-blue-500 sm:text-sm" %>
            </div>
            </div>
          </div>
        </div>

        <div class="mt-6">
      <%= submit "Update", phx_disable_with: "Updating...", class: "bg-blue-500 hover:bg-blue-700 text-white font-poppins py-2 px-4 rounded" %>

        </div>
      </.form>
    </div>
    """
  end

  @impl true
  def handle_event("workout-item", %{"workout_item" => param}, socket) do
  IO.inspect(socket)

    list_of_filter_same_exercise =
      Enum.filter(socket.assigns.workout_template.workout_items, fn each ->
        "#{each.exercise_id}" == param["exercise_id"]
      end)

    list_of_same_exercise =
      Enum.group_by(list_of_filter_same_exercise, fn each -> each.exercise_id end)
      |> Map.values()

    [current| _tail] =
      if list_of_same_exercise == [] do
        [%{sets_number: 1, current_weight: 0}]
      else
        Enum.map(list_of_same_exercise, fn each_list ->
          workout_item = Enum.at(each_list, -1)

           %{sets_number: workout_item.sets + 1, current_weight: workout_item.weight}
        end)
      end


    {:noreply, assign(socket, sets_number: current.sets_number, current_weight: current.current_weight)}
  end

  @impl true
  def handle_event("update", %{"workout_item" => param}, socket) do
    workout_template_id = socket.assigns.workout_template.id
    sets_number = socket.assigns.sets_number

    exercise_id =
      cond do
        param["exercise_id"] == "" -> 0
        param["exercise_id"] -> String.to_integer(param["exercise_id"])
      end

    case WorkoutTemplates.create_workout_item(
           Map.put(param, "workout_template_id", workout_template_id)
         ) do
      {:ok, workout_item} ->

        {:noreply,
         socket
         |> put_flash(:info, " created successfully")
         |> assign(sets_number: sets_number + 1, exercise_id: exercise_id)}

      # |> push_redirect(to: "/workout_templates/#{workout_item.workout_template_id}/edit")

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
