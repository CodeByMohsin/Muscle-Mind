defmodule FitnessWeb.UserProfileLive do
  use FitnessWeb, :live_view

  alias Fitness.Accounts
  alias Fitness.WorkoutTemplates

  def mount(params, session, socket) do
    socket =
      socket
      |> assign(:page_title, "User Profile")
      |> assign(:three_dots, :off)
      |> assign(:chart_data, chart_data_workout(socket, socket.assigns[:current_user].id))

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""

    <div class="scoreboard bg-blue-100 rounded-lg shadow-lg p-6 mb-8">
      <div>
        <a href="/users/settings" class="flex justify-end"><svg class="w-8 h-8" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><g stroke-width="0"></g><g stroke-linecap="round" stroke-linejoin="round"></g><g> <path d="M20.1 9.2214C18.29 9.2214 17.55 7.9414 18.45 6.3714C18.97 5.4614 18.66 4.3014 17.75 3.7814L16.02 2.7914C15.23 2.3214 14.21 2.6014 13.74 3.3914L13.63 3.5814C12.73 5.1514 11.25 5.1514 10.34 3.5814L10.23 3.3914C9.78 2.6014 8.76 2.3214 7.97 2.7914L6.24 3.7814C5.33 4.3014 5.02 5.4714 5.54 6.3814C6.45 7.9414 5.71 9.2214 3.9 9.2214C2.86 9.2214 2 10.0714 2 11.1214V12.8814C2 13.9214 2.85 14.7814 3.9 14.7814C5.71 14.7814 6.45 16.0614 5.54 17.6314C5.02 18.5414 5.33 19.7014 6.24 20.2214L7.97 21.2114C8.76 21.6814 9.78 21.4014 10.25 20.6114L10.36 20.4214C11.26 18.8514 12.74 18.8514 13.65 20.4214L13.76 20.6114C14.23 21.4014 15.25 21.6814 16.04 21.2114L17.77 20.2214C18.68 19.7014 18.99 18.5314 18.47 17.6314C17.56 16.0614 18.3 14.7814 20.11 14.7814C21.15 14.7814 22.01 13.9314 22.01 12.8814V11.1214C22 10.0814 21.15 9.2214 20.1 9.2214ZM12 15.2514C10.21 15.2514 8.75 13.7914 8.75 12.0014C8.75 10.2114 10.21 8.7514 12 8.7514C13.79 8.7514 15.25 10.2114 15.25 12.0014C15.25 13.7914 13.79 15.2514 12 15.2514Z" fill="#292D32"></path> </g></svg></a>
      </div>
      <div class="flex justify-center mt-6 pt-6">
      <img src="/images/user-profile.svg" alt="user profile pic" class="w-24 h-24">
      </div>
      <%= if @three_dots == :off do %>
      <span class="flex justify-center pt-4 ml-13 text-2xl font-poppins">
      <%= assigns[:current_user].name %> <button phx-click="open"><svg class="w-4 h-4 mt-2 mb-2" viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg" fill="#000000" class="bi bi-three-dots-vertical"><g stroke-width="0"></g><g stroke-linecap="round" stroke-linejoin="round"></g><g> <path d="M9.5 13a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0zm0-5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0zm0-5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0z"></path> </g></svg></button>
      </span>
      <% else %>
      <span class="flex justify-center pt-4 text-2xl font-poppins rounded-lg">
      <form  action="#" phx-submit="update_name">
        <%= text_input :name, :text, autocomplete: "off", placeholder: "Edit Name", value: "", class: "flex-grow outline-none font-poppins rounded" %>
        <%= submit "" %>
      </form>
      <button phx-click="close">
      <svg class="w-6 h-6 mb-2 fill-current text-red-500 hover:text-red-600" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M12 10.586l3.293-3.293a1 1 0 0 1 1.414 1.414L13.414 12l3.293 3.293a1 1 0 1 1-1.414 1.414L12 13.414l-3.293 3.293a1 1 0 1 1-1.414-1.414L10.586 12 7.293 8.707a1 1 0 0 1 1.414-1.414L12 10.586z"/></svg>
      </button>
      </span>
      <% end %>

      <span class="flex justify-center text-orange-600  pt-2 text-sm font-poppins">
      @<%= assigns[:current_user].username %>
      </span>
    </div>
    <div class="flex justify-center">
      <span class="text-2xl text-gray-600 font-poppins font-semibold pr-96">[ All Workout ]</span>
      <span class="text-2xl text-gray-600 font-poppins font-semibold pl-96">[ Current Weight ]</span>
    </div>

      <div id="chart" phx-update="ignore" phx-hook="RenderChart" class="flex justify-items-center">
        <% bar_data = Jason.encode!([["Total Sets", @chart_data.total_sets],["Total Reps", @chart_data.total_reps],["Total Weight", @chart_data.total_weight] ]) %>
        <%= raw Chartkick.bar_chart bar_data, stacked: true, colors: ["#FF5733"] %>

        <% datetime_data = Jason.encode!(%{"2013-03-10 00:00:00 -0800": 45, "2013-06-10 00:00:00 -0800": 56, "2013-04-10 00:00:00 -0800": 34}) %>
        <%= raw Chartkick.line_chart datetime_data, colors: ["#FF5733", "#5DADE2", "#58D68D"] %>
      </div>
    """
  end

  @impl true
  def handle_event("open", _payload, socket) do
    {:noreply, assign(socket, three_dots: :no)}
  end

  @impl true
  def handle_event("close", _payload, socket) do
    {:noreply, assign(socket, three_dots: :off)}
  end

  @impl true
  def handle_event("update_name", %{"name" => %{"text" => updated_name}}, socket) do
     Accounts.update_user_name(socket.assigns[:current_user], %{"name" => updated_name})


     {:noreply,
         socket
         |> put_flash(:info, "Name updated successfully")
         |> push_redirect(to: "/profile")}
  end

  defp chart_data_workout(socket, id) do
    list_complete_workout_templates =
      Enum.filter(WorkoutTemplates.list_workout_templates(), fn workout_template ->
        workout_template.user_id == id and workout_template.is_finished == true
      end)

    preload_workout_items_list =
      Enum.map(list_complete_workout_templates, fn each ->
        workout_template = WorkoutTemplates.get_workout_template!(each.id)
        workout_template.workout_items
      end)
      |> List.flatten()

    Enum.reduce(
      preload_workout_items_list,
      %{total_weight: 0, total_sets: 0, total_reps: 0},
      fn each_item, %{total_weight: value, total_sets: value2, total_reps: value3} ->
        %{
          total_weight: value + each_item.weight,
          total_sets: value2 + each_item.sets,
          total_reps: value3 + each_item.reps
        }
      end
    )
  end
end
