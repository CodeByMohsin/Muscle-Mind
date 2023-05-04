defmodule FitnessWeb.WorkoutTemplateLive.WorkoutZone do
  use FitnessWeb, :live_view

  alias Fitness.WorkoutTemplates
  alias Fitness.WorkoutTemplates.WorkoutItem
  alias Fitness.Exercises

  @impl true
  def mount(params, session, socket) do

    {:ok, socket}
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

      <div class="flex justify-center">
        <%= if @timer_status == :running do %>
        <div class="flex items-center">
          <button class="ml-4 px-6 py-4 bg-red-500 text-white rounded-full hover:bg-red-600 focus:outline-none focus:ring-2 focus:ring-black-500 focus:ring-opacity-100 transition-colors" phx-click="stop">
            <svg class="h-6 w-6 text-white" fill="#ffffff" viewBox="0 0 512 512">
              <path d="M256,0C114.617,0,0,114.615,0,256s114.617,256,256,256s256-114.615,256-256S397.383,0,256,0z M224,320 c0,8.836-7.164,16-16,16h-32c-8.836,0-16-7.164-16-16V192c0-8.836,7.164-16,16-16h32c8.836,0,16,7.164,16,16V320z M352,320 c0,8.836-7.164,16-16,16h-32c-8.836,0-16-7.164-16-16V192c0-8.836,7.164-16,16-16h32c8.836,0,16,7.164,16,16V320z"></path>
            </svg>
          </button>
        </div>
        <% end %>
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
        <span class="bg-gray-500 font-poppins hover:bg-gray-600 text-white rounded-lg px-4 py-2"> <%= live_redirect "Back", to: Routes.workout_template_show_path(@socket, :show, @workout_template) %></span>
      </div>

      <div class="bg-white  p-8">

      <%= if @workout_template.workout_items != [] do %>
      <div class="bg-purple-200 rounded-lg shadow-lg p-6 mb-8">


    <div class="rounded-lg p-8 mb-10">
      <% list_of_same_exercise = Enum.group_by(@workout_template.workout_items, fn each -> each.exercise_id end) |> Map.values() %>

      <%= for each_list <- list_of_same_exercise do %>
      <% [workout_item_map | _] = each_list %>
         <div class="bg-gray-100 rounded-lg shadow-md p-4 mb-4 transform hover:scale-105 transition duration-200">
            <div class="flex justify-between items-center mb-4">
               <a href={"/exercises/#{workout_item_map.exercise_id}"}>
                  <h2 class="text-lg font-poppins text-gray-800"><%= Fitness.Exercises.get_exercise!(workout_item_map.exercise_id).name %></h2>
               </a>
               <span class="bg-yellow-400 hover:bg-yellow-600 font-poppins text-white px-2 py-1 rounded-full text-sm font-semibold"><%= length(each_list) %> sets</span>
            </div>

            <table class="w-full">
            <thead class="border-b border-pink-400">
               <tr class="text-gray-600 font-poppins">
                  <th class="text-left py-2">Sets</th>
                  <th class="text-left py-2">Reps</th>
                  <th class="text-left py-2">Weight</th>
               </tr>
            </thead>
            <tbody>
            <%= for workout_item <- each_list do%>
            <.form
            let={f}
            for={@changeset}
            id="created-workout-item"
            phx-change="update">
               <tr class=" font-poppins">
               <td class="text-gray-800 py-2">
                  <%= workout_item.sets %>
                  </td>
                  <td class="text-gray-800 py-2">
                  <%= workout_item.reps %>
                  </td>
                  <td class="text-gray-800 py-2 pr-0">
                  <%= workout_item.weight %>
                  </td>

                  <td class="text-gray-800 py-2 pr-0">
                  <%= workout_item.weight_unit %>
                  </td>

                  <td class="text-gray-800 py-2">
                  <%= if @workout_start != :not_begin do %>
                  <%= checkbox f, :check_box, value: workout_item.check_box, phx_value_id: workout_item.id, class: "form-checkbox h-5 w-5 rounded-full text-purple-500 transition duration-150 ease-in-out" %>
                  <input checked={workout_item.check_box}  name="workout_item_id" type="hidden"  value={"#{workout_item.id}"} class= "form-checkbox h-5 w-5 rounded-full text-purple-500 transition duration-150 ease-in-out" phx-click="update" >
                 <% else %>
                 <span><svg class="w-4 h-4 fill-current text-grey-400 hover:text-grey-600" version="1.0" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 64 64" enable-background="new 0 0 64 64" xml:space="preserve" fill="#000000"><g id="SVGRepo_bgCarrier" stroke-width="0"></g><g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g><g id="SVGRepo_iconCarrier"> <path fill="#231F20" d="M52,24h-4v-8c0-8.836-7.164-16-16-16S16,7.164,16,16v8h-4c-2.211,0-4,1.789-4,4v32c0,2.211,1.789,4,4,4h40 c2.211,0,4-1.789,4-4V28C56,25.789,54.211,24,52,24z M32,48c-2.211,0-4-1.789-4-4s1.789-4,4-4s4,1.789,4,4S34.211,48,32,48z M40,24 H24v-8c0-4.418,3.582-8,8-8s8,3.582,8,8V24z"></path> </g></svg></span>
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

    <%= if @workout_template.workout_items != [] do %>
    <div class="flex justify-center items-center px-6 pr-8">
    <%= if @timer_status == :running do %>
      <span><button class="bg-purple-500 font-poppins hover:bg-purple-600 text-white rounded-lg px-6 py-4 mr-2">Finish Workout</button></span>
      <% end %>
    </div>
    <% end %>
    </div>

    """
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    changeset = WorkoutTemplates.change_workout_item(%WorkoutItem{})

    {:noreply,
    socket
    |> assign(:workout_template, WorkoutTemplates.get_workout_template!(id))
    |> assign(:changeset, changeset)
    |> assign(:update_param, %{})
    |> assign(:time, ~T[00:00:00])
    |> assign(:timer_status, :stopped)
    |> assign(:workout_start, :not_begin)}
  end

  # update checkbox

  @impl true
  def handle_event("update", %{"workout_item" => %{"check_box" => check_box_value}, "workout_item_id" => id}, socket) do

    id = String.to_integer(id)
    check_box_value = String.to_atom(check_box_value)

    workout_item = WorkoutTemplates.get_workout_item!(id)
    WorkoutTemplates.update_workout_item(workout_item, %{"check_box" => check_box_value})

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
