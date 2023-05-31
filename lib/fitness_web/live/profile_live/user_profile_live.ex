defmodule FitnessWeb.UserProfileLive do
  use FitnessWeb, :live_view

  alias Fitness.Accounts.Services.ChartData

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "User Profile")
      |> assign(:kebab_menu, :off)
      |> assign(:chart_data, ChartData.all_complete_workout_chart_data(socket.assigns[:current_user].id))

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""

    <div class="p-6 mb-8 bg-blue-100 rounded-lg shadow-lg scoreboard">
      <div>
        <a href="/users/settings" class="flex justify-end"><svg class="w-8 h-8" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><g stroke-width="0"></g><g stroke-linecap="round" stroke-linejoin="round"></g><g> <path d="M20.1 9.2214C18.29 9.2214 17.55 7.9414 18.45 6.3714C18.97 5.4614 18.66 4.3014 17.75 3.7814L16.02 2.7914C15.23 2.3214 14.21 2.6014 13.74 3.3914L13.63 3.5814C12.73 5.1514 11.25 5.1514 10.34 3.5814L10.23 3.3914C9.78 2.6014 8.76 2.3214 7.97 2.7914L6.24 3.7814C5.33 4.3014 5.02 5.4714 5.54 6.3814C6.45 7.9414 5.71 9.2214 3.9 9.2214C2.86 9.2214 2 10.0714 2 11.1214V12.8814C2 13.9214 2.85 14.7814 3.9 14.7814C5.71 14.7814 6.45 16.0614 5.54 17.6314C5.02 18.5414 5.33 19.7014 6.24 20.2214L7.97 21.2114C8.76 21.6814 9.78 21.4014 10.25 20.6114L10.36 20.4214C11.26 18.8514 12.74 18.8514 13.65 20.4214L13.76 20.6114C14.23 21.4014 15.25 21.6814 16.04 21.2114L17.77 20.2214C18.68 19.7014 18.99 18.5314 18.47 17.6314C17.56 16.0614 18.3 14.7814 20.11 14.7814C21.15 14.7814 22.01 13.9314 22.01 12.8814V11.1214C22 10.0814 21.15 9.2214 20.1 9.2214ZM12 15.2514C10.21 15.2514 8.75 13.7914 8.75 12.0014C8.75 10.2114 10.21 8.7514 12 8.7514C13.79 8.7514 15.25 10.2114 15.25 12.0014C15.25 13.7914 13.79 15.2514 12 15.2514Z" fill="#292D32"></path> </g></svg></a>
        <h1 class="mb-4 text-3xl text-center font-poppins">Profile</h1>
      </div>
      <div class="flex justify-center pt-6 mt-6">
      <img src={assigns[:current_user].image} alt="user profile pic" class="w-32 border-2 border-gray-800 rounded-full h-w-32">
      </div>
      <%= if @kebab_menu == :off do %>
      <span class="flex justify-center pt-4 text-2xl ml-13 font-poppins">
      <%= assigns[:current_user].name %> <button phx-click="open"><svg class="w-4 h-4 mt-2 mb-2" viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg" fill="#000000" class="bi bi-three-dots-vertical"><g stroke-width="0"></g><g stroke-linecap="round" stroke-linejoin="round"></g><g> <path d="M9.5 13a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0zm0-5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0zm0-5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0z"></path> </g></svg></button>
      </span>
      <% else %>
      <span class="flex justify-center pt-4 text-2xl ml-13 font-poppins">
      <%= assigns[:current_user].name %> <button phx-click="close"><svg class="w-4 h-4 mt-2 mb-2" viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg" fill="#000000" class="bi bi-three-dots-vertical"><g stroke-width="0"></g><g stroke-linecap="round" stroke-linejoin="round"></g><g> <path d="M9.5 13a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0zm0-5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0zm0-5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0z"></path> </g></svg></button>
      </span>
      <.modal>
        <.live_component id={assigns[:current_user].id} module={FitnessWeb.ProfileLive.UpdateUserProfileForm} current_user={assigns[:current_user]} />
      </.modal>
      <% end %>

      <span class="flex justify-center pt-2 text-base text-orange-600 font-poppins">
      @<%= assigns[:current_user].username %>
      </span>
       <a href="/score_board">
       <div class="flex justify-center pt-4 buttonscore">
        <div class="box">T</div>
        <div class="box">O</div>
        <div class="box">T</div>
        <div class="box">A</div>
        <div class="box">L</div>
       </div>
       <div class="flex justify-center text-5xl pt-4 font-poppins font-semibold text-yellow-500 font-outline-2 drop-shadow-[0_1.2px_1.2px_rgba(0,0,0,0.8)]">
       <%= assigns[:current_user].player_score %>
       </div>
       </a>


      </div>

      <div class="relative flex justify-center bg-white rounded-lg shadow-lg">
        <span class="text-2xl font-semibold text-gray-600 font-poppins pr-80"> Training Volume </span>
        <span class="text-2xl font-semibold text-gray-600 font-poppins pl-80"> Current Weight </span>
      </div>

      <div id="chart" phx-update="ignore" class="flex justify-items-center">
        <% bar_data = Jason.encode!([["Total Sets", @chart_data.total_sets],["Total Reps", @chart_data.total_reps],["Total Weight", @chart_data.total_weight] ]) %>
        <%= raw Chartkick.bar_chart bar_data, stacked: true, colors: ["#FF5733"] %>

        <% datetime_data = Jason.encode!(%{"2023-03-10 00:00:00 -0800": 45, "2023-06-10 00:00:00 -0800": 56, "2023-04-10 00:00:00 -0800": 54, "2023-09-10 00:00:00 -0200": 64, "2023-01-10 00:00:00 -0800": 84, "2023-07-10 00:00:00 -0800": 74, "2023-02-10 00:00:00 -0800": 64}) %>
        <%= raw Chartkick.area_chart datetime_data, colors: ["#58D68D"] %>
      </div>

    """
  end

  @impl true
  def handle_event("open", _payload, socket) do
    {:noreply, assign(socket, kebab_menu: :on)}
  end

  @impl true
  def handle_event("close", _payload, socket) do
    {:noreply, assign(socket, kebab_menu: :off)}
  end
end
