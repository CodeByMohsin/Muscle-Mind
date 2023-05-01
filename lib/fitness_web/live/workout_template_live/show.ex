defmodule FitnessWeb.WorkoutTemplateLive.Show do
  use FitnessWeb, :live_view

  alias Fitness.WorkoutTemplates
  alias Fitness.Accounts
  alias Fitness.WorkoutTemplates.WorkoutItem
  alias Fitness.Exercises

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
     |> assign(:exercises, exercises)
     |> assign(:update_param, %{})}
  end

  @impl true
  def handle_event("workout-item", %{"workout_item" => param}, socket) do

     update_param = Map.put(socket.assigns.update_param, "workout_item", param)

    list_of_filter_same_exercise =
      Enum.filter(socket.assigns.workout_template.workout_items, fn each ->
        "#{each.exercise_id}" == param["exercise_id"]
      end)

    list_of_same_exercise =
      Enum.group_by(list_of_filter_same_exercise, fn each -> each.exercise_id end)
      |> Map.values()

    [current| _tail] =
      if list_of_same_exercise == [] do
        [%{sets_number: 1, current_weight: 0, exercise_id: 0}]
      else
        Enum.map(list_of_same_exercise, fn each_list ->
          workout_item = Enum.at(each_list, -1)

            %{sets_number: workout_item.sets + 1, current_weight: workout_item.weight, exercise_id: workout_item.exercise_id}
        end)
      end

    {:noreply, assign(socket, sets_number: current.sets_number, current_weight: current.current_weight, exercise_id: current.exercise_id, update_param: update_param)}
  end

  @impl true
  def handle_event("add-set", %{"workout_item" => param}, socket) do
    workout_template_id = socket.assigns.workout_template.id

    case WorkoutTemplates.create_workout_item(
           Map.put(param, "workout_template_id", workout_template_id)
           |> Map.put( "sets", "#{ String.to_integer(param["sets"]) + 1}")
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

 @impl true
  def handle_event("update", %{"id" => id} = params , socket) do
    IO.inspect(params, label: "++++++++++++++++======++++++++++++")

    {:noreply, socket}
  end


  @impl true
  def handle_event("delete", %{"id" => id}, socket) do

    workout_item = WorkoutTemplates.get_workout_item!(id)

    {:ok, list_of_workout_items_after_delete} = WorkoutTemplates.delete_workout_item(workout_item)



    list_of_filter_same_exercise =
        Enum.filter(socket.assigns.workout_template.workout_items, fn each ->
          each.exercise_id == list_of_workout_items_after_delete.exercise_id
        end)

      list_of_same_exercise =
        Enum.group_by(list_of_filter_same_exercise, fn each -> each.exercise_id end)
        |> Map.values()

        Enum.map(list_of_same_exercise, fn each ->

        order_change_list = Enum.filter(each, fn workout_item -> workout_item.sets > list_of_workout_items_after_delete.sets end)

        if order_change_list != [] do
          Enum.each(order_change_list, fn each -> WorkoutTemplates.update_workout_item(each, %{"sets" => "#{each.sets - 1}", "reps" => "#{each.reps}", "weight" => "#{each.weight}", "weight_unit" => "#{each.weight_unit}", "exercise_id" => "#{each.exercise_id}", "workout_template_id" => "#{each.workout_template_id}" }) end)
        end

      end)

        socket =
          socket
          |> push_redirect(to: "/workout_templates/#{workout_item.workout_template_id}")

    {:noreply, socket}
  end

  defp page_title(:show), do: "Show Workout template"
  defp page_title(:edit), do: "Edit Workout template"
end
