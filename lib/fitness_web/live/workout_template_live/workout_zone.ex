defmodule FitnessWeb.WorkoutTemplateLive.WorkoutZone do
  use FitnessWeb, :live_view

  alias Fitness.WorkoutTemplates
  alias Fitness.WorkoutTemplates.WorkoutItem

  alias FitnessWeb.WorkoutTemplateLive.CheckBoxesLiveComponent

  alias Fitness.WorkoutTemplates.Services.WorkoutItemLogic
  alias Fitness.Accounts.Services.PlayerScores

  @impl true
  def mount(params, _session, socket) do
    changeset = WorkoutTemplates.change_workout_item(%WorkoutItem{})
    workout_template = WorkoutTemplates.get_workout_template!(params["id"])

    check_complete_checkbox_list =
      Enum.filter(workout_template.workout_items, fn each -> each.check_box == true end)

    {:ok,
     socket
     |> assign(:changeset, changeset)
     |> assign(:update_param, %{})
     |> assign(:time, ~T[00:00:00])
     |> assign(:timer_status, :stopped)
     |> assign(:workout_start, :not_begin)
     |> assign(:check_complete_checkbox_list, check_complete_checkbox_list)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1 class="flex items-center justify-center pt-3 mb-4 text-4xl font-light font-poppins ">
      <%= String.upcase(@workout_template.name) %>
    </h1>

    <%= if @workout_template.workout_items != [] do %>
      <div class="flex items-center justify-center pt-3 mb-4">
        <div class="p-3 bg-gray-200 rounded-lg">
          <h1 class="text-6xl font-bold text-gray-800">
            <%= @time |> Time.truncate(:second) |> Time.to_string() %>
          </h1>
        </div>
      </div>
    <% end %>

    <div class="flex justify-between px-6 pr-8">
      <%= if @workout_template.workout_items != [] do %>
        <%= if @timer_status != :running do %>
          <a
            href="#_"
            phx-click="start_workout"
            ,
            class="relative px-5 py-3 overflow-hidden text-lg text-gray-600 bg-gray-100 border border-gray-100 rounded-lg shadow-inner font-poppins group"
          >
            <span class="absolute top-0 left-0 w-0 h-0 transition-all duration-200 border-t-2 border-purple-600 group-hover:w-full ease">
            </span>
            <span class="absolute bottom-0 right-0 w-0 h-0 transition-all duration-200 border-b-2 border-purple-600 group-hover:w-full ease">
            </span>
            <span class="absolute top-0 left-0 w-full h-0 transition-all duration-300 delay-200 bg-purple-600 group-hover:h-full ease">
            </span>
            <span class="absolute bottom-0 left-0 w-full h-0 transition-all duration-300 delay-200 bg-purple-600 group-hover:h-full ease">
            </span>
            <span class="absolute inset-0 w-full h-full duration-300 delay-300 bg-purple-500 opacity-0 group-hover:opacity-100">
            </span>
            <span class="relative transition-colors duration-300 delay-200 group-hover:text-white ease">
              Start Workout
            </span>
          </a>
        <% else %>
          <div class="relative group">
            <p class="px-6 py-4 text-4xl text-white bg-white rounded-lg font-poppins hover:bg-yellow-200">
              💪
            </p>
            <span class="tooltip-text font-poppins hidden group-hover:block bg-yellow-600 text-white p-1 rounded-lg absolute text-xs text-center bottom-full -translate-y-3.5 ">
              You will receive 20 points per set and if you complete all sets, you will get 50 points bonus. So, try your best.
            </span>
          </div>
        <% end %>
      <% else %>
        <button></button>
      <% end %>

      <%= if @timer_status != :running do %>
        <div class="relative group">
          <span></span>
          <span class="px-4 py-2 text-white bg-gray-500 rounded-lg font-poppins hover:bg-gray-600">
            <.link navigate={Routes.workout_template_show_path(@socket, :show, @workout_template)}>
              Edit
            </.link>
          </span>
        </div>
      <% else %>
        <div class="relative group">
          <span class="absolute hidden p-1 text-xs text-center text-white -translate-x-16 -translate-y-1 bg-red-400 rounded-lg tooltip-text font-poppins group-hover:block bottom-full ">
            The timer is lost by you
          </span>
          <button class="px-4 py-2 text-white bg-gray-500 rounded-lg font-poppins hover:bg-gray-600">
            <.link navigate={Routes.workout_template_show_path(@socket, :show, @workout_template)}>
              Back
            </.link>
          </button>
        </div>
      <% end %>
    </div>

    <div>
      <.live_component
        module={CheckBoxesLiveComponent}
        id="check-boxes"
        timer_status={@timer_status}
        workout_start={@workout_start}
        changeset={@changeset}
        workout_template={@workout_template}
      />
    </div>

    <%= if @timer_status == :running do %>
      <div class="relative flex items-center justify-center px-6 py-8 pr-8 group">
        <%  %>
        <%= if @check_complete_checkbox_list != [] do %>
          <span class="absolute hidden p-4 text-sm text-left text-white bg-gray-800 rounded-lg tooltip-text font-poppins group-hover:block bottom-full -translate-y-0">
            Have you finished? Please check all the sets as they may be incomplete due to the loss of your bonus points
          </span>
          <button class="px-6 py-4 mr-4 text-white bg-purple-500 rounded-lg font-poppins hover:bg-purple-600">
            <%= link("Finish Workout",
              to: "#",
              phx_click: "finish",
              phx_value_id: @workout_template.id
            ) %>
          </button>
        <% end %>
      </div>
    <% end %>
    """
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:workout_template, WorkoutTemplates.get_workout_template!(id))}
  end

  # update my checkboxes

  @impl true
  def handle_event(
        "workout_complete",
        %{"id" => id, "value" => check_box_value} = _params,
        socket
      ) do
    id = String.to_integer(id)
    check_box_value = String.to_atom(check_box_value)

    check_complete_checkbox_list = WorkoutItemLogic.complete_workout(id, check_box_value)

    {:noreply, assign(socket, :check_complete_checkbox_list, check_complete_checkbox_list)}
  end

  @impl true
  def handle_event("workout_complete", %{"id" => id} = _params, socket) do
    id = String.to_integer(id)
    check_box_value = false

    check_complete_checkbox_list = WorkoutItemLogic.complete_workout(id, check_box_value)

    {:noreply, assign(socket, :check_complete_checkbox_list, check_complete_checkbox_list)}
  end

  # finish workout

  @impl true
  def handle_event("finish", %{"id" => id}, socket) do
    id = String.to_integer(id)
    workout_templates = WorkoutTemplates.list_workout_templates()
    workout_template = WorkoutTemplates.get_workout_template!(id)
    current_user = socket.assigns.current_user

    WorkoutItemLogic.duplicate_workout_template(workout_template)

    PlayerScores.update_new_player_score_and_broadcast_score_board(
      current_user,
      workout_templates
    )

    redirect_value = WorkoutItemLogic.update_workout_template_score(workout_template)

    socket =
      case redirect_value do
        true ->
          socket
          |> put_flash(
            :bonus,
            "Well done #{String.upcase(current_user.name)} for finishing your workout! 🥳 You earned ✨50✨ bonus 🎉 points for completing all of your sets. Keep up the great work! 👍"
          )
          |> push_navigate(to: "/activity_history")

        false ->
          socket
          |> put_flash(
            :loss,
            "Congratulations #{String.upcase(current_user.name)} for completing your workout! However, 😞 you lost 50 bonus points because you missed some sets. Try your best next time 👍"
          )
          |> push_navigate(to: "/activity_history")
      end

    {:noreply, assign(socket, :timer_status, :stopped)}
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
