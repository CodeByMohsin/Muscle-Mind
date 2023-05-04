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
     |> assign(:update_workout_item, %{})}
  end

  @impl true
  def handle_event("workout-item", %{"workout_item" => param}, socket) do
    IO.inspect(param)

    update_workout_item = Map.put(socket.assigns.update_workout_item, "workout_item", param)

    socket =
      socket
      |> assign(:update_workout_item, update_workout_item)


    {:noreply, socket}
  end

  # update changes

  @impl true
  def handle_event("update", %{"id" => id}, socket) do

    update_workout_item = socket.assigns.update_workout_item["workout_item"]
    IO.inspect(update_workout_item)

    workout_item = WorkoutTemplates.get_workout_item!(String.to_integer(id))
    WorkoutTemplates.update_workout_item(workout_item, update_workout_item)

    socket =
      socket
      |> assign(:update_workout_item, %{})
      |> live_redirect(to: "/workout_templates/#{String.to_integer(update_workout_item["workout_template_id"])}")

     {:noreply, socket}
   end

  # Add more set in workout_items

  @impl true
  def handle_event("add-set", param, socket) do

     exercise_id = param["exercise-id"]
     workout_template_id= param["workout-template-id"]
     weight_unit = param["weight-unit"]


     WorkoutTemplates.create_workout_item(
            Map.put(%{}, "sets", "#{ String.to_integer(param["sets"]) + 1}")
            |> Map.put("exercise_id", exercise_id)
            |> Map.put("workout_template_id", workout_template_id)
            |> Map.put("weight_unit",weight_unit)
            |> Map.put("reps", param["reps"])
            |> Map.put("weight", param["weight"])
         )

        socket =
          socket
          |> push_redirect(to: "/workout_templates/#{workout_template_id}")

         {:noreply, socket}

  end



  # delete workout item sets and update the set number

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
          Enum.each(order_change_list, fn each -> WorkoutTemplates.update_workout_item(each, %{"sets" => "#{each.sets - 1}"}) end)
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
