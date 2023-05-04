defmodule FitnessWeb.WorkoutTemplateLive.WorkoutZone do
  use FitnessWeb, :live_view

  alias Fitness.WorkoutTemplates
  alias Fitness.WorkoutTemplates.WorkoutItem
  alias Fitness.Exercises
  alias FitnessWeb.WorkoutTemplateLive.TimerLiveComponent

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

      <div class="flex justify-between items-center px-6 pr-8">
      <%= if @workout_template.workout_items != [] do %>
            <%= if @timer_status != :running do %>
              <button class="bg-yellow-500 font-poppins hover:bg-green-400 text-white text-lg rounded-lg px-6 py-4", phx-click="start_workout">Start Workout</button>
            <% else %>
              <p class="bg-white font-poppins hover:bg-yellow-200 text-white text-4xl rounded-lg px-6 py-4">💪</p>
            <% end %>
        <% else %>
        <button></button>
      <% end %>
        <span class="bg-gray-500 font-poppins hover:bg-gray-600 text-white rounded-lg px-4 py-2"> <%= live_redirect "Edit", to: Routes.workout_template_show_path(@socket, :show, @workout_template) %></span>
      </div>

      <div>
        <.live_component module={TimerLiveComponent} id={"stop-watch-#{Enum.random(1..100)}"} timer_status={@timer_status} workout_start={@workout_start} changeset={@changeset} workout_template={@workout_template} phx_target={TimerLiveComponent}/>
      </div>

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
