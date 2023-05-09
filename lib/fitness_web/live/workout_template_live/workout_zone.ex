defmodule FitnessWeb.WorkoutTemplateLive.WorkoutZone do
  use FitnessWeb, :live_view

  alias Fitness.WorkoutTemplates
  alias Fitness.WorkoutTemplates.WorkoutItem
  alias Fitness.Exercises
  alias FitnessWeb.WorkoutTemplateLive.CheckBoxesLiveComponent
  alias Fitness.Accounts

  @impl true
  def mount(params, session, socket) do
    changeset = WorkoutTemplates.change_workout_item(%WorkoutItem{})

    {:ok,
     socket
     |> assign(:changeset, changeset)
     |> assign(:update_param, %{})
     |> assign(:time, ~T[00:00:00])
     |> assign(:timer_status, :stopped)
     |> assign(:workout_start, :not_begin)}
  end

  def render(assigns) do
    ~H"""

    <h1 class="flex justify-center pt-3 items-center text-4xl mb-4 font-poppins font-light "><%= String.upcase(@workout_template.name) %></h1>

      <%= if @workout_template.workout_items != [] do %>
      <div class="flex justify-center pt-3 items-center mb-4">
        <div class="bg-gray-200 rounded-lg p-3">
            <h1 class="text-6xl font-bold text-gray-800"><%= @time |> Time.truncate(:second) |> Time.to_string() %></h1>
        </div>
      </div>
      <% end %>

      <div class="flex justify-between px-6 pr-8">
      <%= if @workout_template.workout_items != [] do %>
            <%= if @timer_status != :running do %>
              <button class="bg-purple-400 font-poppins hover:bg-pink-400 text-white text-lg rounded-lg px-6 py-4", phx-click="start_workout" , data="Have you finished? Please check all the sets as they may be incomplete due to the loss of your bonus points.">Start Workout</button>
            <% else %>
            <div class=" group relative">
              <p class="bg-white font-poppins hover:bg-yellow-200 text-white text-4xl rounded-lg px-6 py-4">💪</p>
              <span class="tooltip-text font-poppins hidden group-hover:block bg-yellow-600 text-white p-1 rounded-lg absolute text-xs text-center bottom-full -translate-y-3.5 ">
                You will receive 20 points per set and if you complete all sets, you will get 50 points bonus. So, try your best.
              </span>
              </div>
            <% end %>
        <% else %>
        <button></button>
      <% end %>

      <%= if @timer_status != :running do %>
        <div class=" group relative">
         <span>
        </span>
        <span class="bg-gray-500 font-poppins hover:bg-gray-600 text-white rounded-lg px-4 py-2"> <%= live_redirect "Edit", to: Routes.workout_template_show_path(@socket, :show, @workout_template) %></span>
        </div>
        <% else %>
        <div class=" group relative">
        <span class="tooltip-text font-poppins hidden group-hover:block bg-red-400 text-white p-1 rounded-lg absolute text-xs text-center bottom-full -translate-x-16 -translate-y-1 ">
          The timer is lost by you
        </span>
        <button class="bg-gray-500 font-poppins hover:bg-gray-600 text-white rounded-lg px-4 py-2">
          <%= live_redirect "Back", to: Routes.workout_template_show_path(@socket, :show, @workout_template) %>
        </button>
        </div>
      <% end %>
      </div>

      <div>
        <.live_component module={CheckBoxesLiveComponent} id={"check-boxes"} timer_status={@timer_status} workout_start={@workout_start} changeset={@changeset} workout_template={@workout_template} />
      </div>

      <%= if @timer_status == :running do %>
      <div class="flex justify-center items-center px-6 py-8 pr-8 group relative">
        <span class="tooltip-text font-poppins hidden group-hover:block bg-gray-800 text-white p-4 rounded-lg absolute text-sm text-left bottom-full -translate-y-0">
          Have you finished? Please check all the sets as they may be incomplete due to the loss of your bonus points
        </span>
        <button class="bg-purple-500 font-poppins hover:bg-purple-600 text-white rounded-lg px-6 py-4 mr-4">
          <%= link "Finish Workout", to: "#", phx_click: "finish", phx_value_id: @workout_template.id %>
        </button>
      </div>
      <% end %>



      """
      end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    changeset = WorkoutTemplates.change_workout_item(%WorkoutItem{})

    {:noreply,
     socket
     |> assign(:workout_template, WorkoutTemplates.get_workout_template!(id))}
  end

  # update my checkboxes

  @impl true
  def handle_event("update_checkbox", %{"id" => id, "value" => check_box_value} = params, socket) do
    id = String.to_integer(id)
    check_box_value = String.to_atom(check_box_value)

    workout_item = WorkoutTemplates.get_workout_item!(id)
    WorkoutTemplates.update_workout_item(workout_item, %{"check_box" => check_box_value})

    {:noreply, socket}
  end

  @impl true
  def handle_event("update_checkbox", %{"id" => id} = params, socket) do
    id = String.to_integer(id)

    workout_item = WorkoutTemplates.get_workout_item!(id)
    WorkoutTemplates.update_workout_item(workout_item, %{"check_box" => false})

    {:noreply, socket}
  end

  # finish workout

  @impl true
  def handle_event("finish", %{"id" => id}, socket) do
    id = String.to_integer(id)
    workout_template = WorkoutTemplates.get_workout_template!(id)

    user_id = socket.assigns.current_user.id
    user = Accounts.get_user!(user_id)

    player_score = user.player_score
    workout_template_score = workout_template.workout_template_score

    list_of_complete_workout_items =
      Enum.filter(workout_template.workout_items, fn each ->
        each.check_box == true
      end)

    if length(list_of_complete_workout_items) == length(workout_template.workout_items) do
      total_score = Enum.reduce(list_of_complete_workout_items, 0, fn _each, acc -> acc + 20 end)

      workout_template_score_update =
        WorkoutTemplates.update_workout_template(workout_template, %{
          "workout_template_score" => "#{total_score + 50}",
          "is_finished" => "true"
        })

      socket =
        socket
        |> put_flash(
          :bonus,
          "Well done #{String.upcase(user.name)} for finishing your workout! 🥳 You earned ✨50✨ bonus 🎉 points for completing all of your sets. Keep up the great work! 👍"
        )
        |> push_redirect(to: "/activity_history")

      {:noreply, assign(socket, :timer_status, :stopped)}
    else
      total_score = Enum.reduce(list_of_complete_workout_items, 0, fn _each, acc -> acc + 20 end)

      workout_template_score_update =
        WorkoutTemplates.update_workout_template(workout_template, %{
          "workout_template_score" => "#{total_score}",
          "is_finished" => "true"
        })

      socket =
        socket
        |> put_flash(
          :loss,
          "Congratulations #{String.upcase(user.name)} for completing your workout! However, 😞 you lost 50 bonus points because you missed some sets. Try your best next time 👍"
        )
        |> push_redirect(to: "/activity_history")

      {:noreply, assign(socket, :timer_status, :stopped)}
    end
  end

  # timer logic

  @impl true
  def handle_event("start_workout", _value, socket) do
    Process.send_after(self(), :tick, 1000)
    {:noreply, assign(socket, timer_status: :running, workout_start: :started)}
  end

  @impl true
  def handle_event("start", _value, socket) do
    Process.send_after(self(), :tick, 1000)
    {:noreply, assign(socket, :timer_status, :running)}
  end

  @impl true
  def handle_event("stop", _value, socket) do
    {:noreply, assign(socket, :timer_status, :stopped)}
  end

  @impl true
  def handle_info(:tick, socket) do
    if socket.assigns.timer_status == :running do
      Process.send_after(self(), :tick, 1000)
      time = Time.add(socket.assigns.time, 1, :second)

      {:noreply, assign(socket, :time, time)}
    else
      {:noreply, socket}
    end
  end
end
