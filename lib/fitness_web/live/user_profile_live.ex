defmodule FitnessWeb.UserProfileLive do
  use FitnessWeb, :live_view

  alias Fitness.Accounts
  alias Fitness.WorkoutTemplates

  def mount(params, session, socket) do
    socket =
      socket
      |> assign(:page_title, "User Profile")
      |> assign(:chart_data, chart_data_workout(socket, socket.assigns[:current_user].id))

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""

    <div class="scoreboard bg-blue-100 rounded-lg shadow-lg p-6 mb-8">
      <div>
        <a href="/users/settings" class="flex justify-end"><svg class="w-8 h-8" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><g id="SVGRepo_bgCarrier" stroke-width="0"></g><g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g><g id="SVGRepo_iconCarrier"> <path d="M20.1 9.2214C18.29 9.2214 17.55 7.9414 18.45 6.3714C18.97 5.4614 18.66 4.3014 17.75 3.7814L16.02 2.7914C15.23 2.3214 14.21 2.6014 13.74 3.3914L13.63 3.5814C12.73 5.1514 11.25 5.1514 10.34 3.5814L10.23 3.3914C9.78 2.6014 8.76 2.3214 7.97 2.7914L6.24 3.7814C5.33 4.3014 5.02 5.4714 5.54 6.3814C6.45 7.9414 5.71 9.2214 3.9 9.2214C2.86 9.2214 2 10.0714 2 11.1214V12.8814C2 13.9214 2.85 14.7814 3.9 14.7814C5.71 14.7814 6.45 16.0614 5.54 17.6314C5.02 18.5414 5.33 19.7014 6.24 20.2214L7.97 21.2114C8.76 21.6814 9.78 21.4014 10.25 20.6114L10.36 20.4214C11.26 18.8514 12.74 18.8514 13.65 20.4214L13.76 20.6114C14.23 21.4014 15.25 21.6814 16.04 21.2114L17.77 20.2214C18.68 19.7014 18.99 18.5314 18.47 17.6314C17.56 16.0614 18.3 14.7814 20.11 14.7814C21.15 14.7814 22.01 13.9314 22.01 12.8814V11.1214C22 10.0814 21.15 9.2214 20.1 9.2214ZM12 15.2514C10.21 15.2514 8.75 13.7914 8.75 12.0014C8.75 10.2114 10.21 8.7514 12 8.7514C13.79 8.7514 15.25 10.2114 15.25 12.0014C15.25 13.7914 13.79 15.2514 12 15.2514Z" fill="#292D32"></path> </g></svg></a>
      </div>
      <h1 class="text-center text-3xl mb-4 font-poppins">Profile</h1>
      <div class="flex justify-center mt-6 pt-6">
      <img src="/images/user-profile.svg" alt="user profile pic" class="w-24 h-24">
      </div>
      <span class="flex justify-center pt-4 text-2xl font-poppins">
      <%= assigns[:current_user].name %>
      </span>
      <span class="flex justify-center text-orange-600  pt-2 text-sm font-poppins">
      @<%= assigns[:current_user].username %>
      </span>
      <span class="flex justify-center pt-2 pb-6 text-xm text-gray-600 hover:text-lime-500 font-poppins">Total Score: <%= assigns[:current_user].player_score %></span>
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
