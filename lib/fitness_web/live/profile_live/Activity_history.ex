defmodule FitnessWeb.WorkoutTemplateLive.ActivityHistory do
  use FitnessWeb, :live_view

  alias Fitness.WorkoutTemplates

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, workout_templates: WorkoutTemplates.list_workout_templates())}
  end

  @impl true
  def render(assigns) do
    ~H"""

    <div class="p-6 mb-8 bg-blue-100 shadow-lg">
      <h1 class="flex items-center justify-center pt-0 mb-4 text-4xl font-poppins">History</h1>

            <%= if length(@workout_templates) >= 1 do %>
          <% user_template_owner = Enum.filter(@workout_templates, fn each -> each.user_id == assigns[:current_user].id end) %>


          <% workout_template_are_finished = Enum.filter(user_template_owner, fn each -> each.is_finished == true end) %>
          <div class="flex justify-end mb-4">
          <p class="relative px-6 py-4 text-white rounded-lg font-poppins hover:text-xl group">
          <span class="absolute inset-0 w-full h-full transition duration-300 transform -translate-x-1 -translate-y-1 bg-purple-800 ease opacity-80 group-hover:translate-x-0 group-hover:translate-y-0"></span>
          <span class="absolute inset-0 w-full h-full transition duration-300 transform translate-x-1 translate-y-1 bg-pink-800 ease opacity-80 group-hover:translate-x-0 group-hover:translate-y-0 mix-blend-screen"></span>
          <span class="relative"><%= length(workout_template_are_finished) %> Workouts</span>
          </p>
          </div>
          <div class="grid grid-cols-2 gap-4">
          <%= for workout_template <- Enum.reverse(workout_template_are_finished) do %>
            <div id={"workout_template-#{workout_template.id}"}, class="relative bg-white rounded-lg shadow-lg">

              <div class="flex justify-between px-6 py-4 border-gray-400 rounded">

              <p class="text-base text-orange-500"><%= Calendar.strftime(workout_template.updated_at, "%B %-d, %Y") %></p>
                <a href={"/workout_templates/#{workout_template.id}"} class="mb-2 text-xl text-gray-700 font-poppins"><%= String.upcase(workout_template.name) %> </a>
                <p class="relative inline-flex items-center justify-start px-6 py-3 overflow-hidden text-xl font-medium transition-all bg-white rounded font-poppins hover:bg-white group">
                <span class="w-48 h-48 rounded rotate-[-40deg] bg-purple-600 absolute bottom-0 left-0 -translate-x-full ease-out duration-500 transition-all translate-y-full mb-9 ml-9 group-hover:ml-0 group-hover:mb-32 group-hover:translate-x-0"></span>
                <span class="relative w-full text-left text-black transition-colors duration-300 ease-in-out group-hover:text-white">Score: <%= workout_template.workout_template_score %></span>
                </p>
              </div>
              <% list_of_same_exercise = Enum.group_by(workout_template.workout_items, fn each -> each.exercise_id end) |> Map.values() %>
              <%= for each_list <- list_of_same_exercise do %>
              <% [workout_item_map | _] = each_list %>
              <% each_list = Enum.filter(each_list, fn each -> each.check_box == true end) %>
              <div class="pb-1">
                <span class="pt-4 pl-6 mr-2 text-base text-gray-500"><%= length(each_list) %> ✕ <%= Fitness.Exercises.get_exercise!(workout_item_map.exercise_id).name %> (<%= Fitness.Exercises.get_exercise!(workout_item_map.exercise_id).body_part %>)</span>
               </div>
              <% end %>
              </div>
              <% end %>
            </div>
            <% end %>

      </div>

    """
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :history, _params) do
    preload_workout_template =
      for each_workout_template <- socket.assigns.workout_templates do
        WorkoutTemplates.get_workout_template!(each_workout_template.id)
      end

    socket
    |> assign(:page_title, "Listing Activity History")
    |> assign(:workout_templates, preload_workout_template)
  end
end
