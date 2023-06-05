defmodule FitnessWeb.WorkoutTemplateLive.CheckBoxesLiveComponent do
  use FitnessWeb, :live_component

  alias Fitness.WorkoutTemplates
  alias Fitness.WorkoutTemplates.WorkoutItem
  alias Fitness.Exercises

  @impl true
  def update(assigns, socket) do

    {:ok,
    socket
    |> assign(:workout_template, assigns.workout_template)
    |> assign(:changeset, assigns.changeset)
    |> assign(:update_param, %{})
    |> assign(:time, ~T[00:00:00])
    |> assign(:timer_status, assigns.timer_status)
    |> assign(:workout_start, assigns.workout_start)}
  end

  def render(assigns) do
    ~H"""
    <div class="p-8 bg-white">

    <%= if @workout_template.workout_items != [] do %>
    <div class="p-6 mb-8 bg-purple-300 rounded-lg shadow-lg">


    <div class="p-8 mb-10 rounded-lg">
    <% list_of_same_exercise = Enum.group_by(@workout_template.workout_items, fn each -> each.exercise_id end) |> Map.values() %>

    <%= for each_list <- list_of_same_exercise do %>
    <% [workout_item_map | _] = each_list %>
      <div class="p-4 mb-4 transition duration-200 transform bg-gray-100 rounded-lg shadow-md hover:scale-105">
          <div class="flex items-center justify-between mb-4">
            <a href={"/exercises/#{workout_item_map.exercise_id}"}>
                <h2 class="text-lg text-gray-800 font-poppins"><%= Fitness.Exercises.get_exercise!(workout_item_map.exercise_id).name %> (<%= Fitness.Exercises.get_exercise!(workout_item_map.exercise_id).body_part %>)</h2>
            </a>
            <span class="px-2 py-1 text-sm font-semibold text-white bg-yellow-400 rounded-full hover:bg-yellow-600 font-poppins"><%= length(each_list) %> sets</span>
          </div>

          <table class="w-full">
          <thead class="border-b border-pink-400">
            <tr class="text-gray-600 font-poppins">
                <th class="py-2 text-left">Sets</th>
                <th class="py-2 text-left">Reps</th>
                <th class="py-2 text-left">Weight</th>
            </tr>
          </thead>
          <tbody>
          <%= for workout_item <- each_list do%>
          <.form
          let={f}
          for={@changeset}
          id={"created-workout-item-#{workout_item.id}"}
          >
            <tr class=" font-poppins">
            <td class="py-2 text-gray-800">
                <%= workout_item.sets %>
                </td>
                <td class="py-2 text-gray-800">
                <%= workout_item.reps %>
                </td>
                <td class="py-2 pr-0 text-gray-800">
                <%= workout_item.weight %>
                </td>

                <td class="py-2 pr-0 text-gray-800">
                <%= workout_item.weight_unit %>
                </td>

                <td class="py-2 text-gray-800">
                <%= if @workout_start != :not_begin do %>
                <label class="checkbox-btn">
                    <label for="checkbox"></label>
                    <%= checkbox f, :check_box, value: workout_item.check_box,  class: "form-checkbox h-5 w-5 rounded-full text-purple-500 transition duration-150 ease-in-out", phx_click: "workout_complete", phx_value_id: workout_item.id %>
                    <span class="rounded-lg checkmark"></span>
                </label>
                  <% else %>
                  <span><svg class="w-4 h-4 fill-current text-grey-400 hover:text-grey-600" version="1.0" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 64 64" enable-background="new 0 0 64 64" xml:space="preserve" fill="#000000"><g stroke-width="0"></g><g  stroke-linecap="round" stroke-linejoin="round"></g><g> <path fill="#231F20" d="M52,24h-4v-8c0-8.836-7.164-16-16-16S16,7.164,16,16v8h-4c-2.211,0-4,1.789-4,4v32c0,2.211,1.789,4,4,4h40 c2.211,0,4-1.789,4-4V28C56,25.789,54.211,24,52,24z M32,48c-2.211,0-4-1.789-4-4s1.789-4,4-4s4,1.789,4,4S34.211,48,32,48z M40,24 H24v-8c0-4.418,3.582-8,8-8s8,3.582,8,8V24z"></path> </g></svg></span>
                  <% end %>
                </td>
              </tr>
            </.form>
              <% end %>
            </tbody>
          </table>
        </div>
      <% end %>
      </div>
      </div>
      <% end %>
    </div>

    """
  end

end
