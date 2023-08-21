defmodule FitnessWeb.ScoreBoardLive do
  use FitnessWeb, :live_view

  alias Fitness.Accounts
  alias Fitness.WorkoutTemplates

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Fitness.PubSub, "score_board")

    socket =
      socket
      |> assign(:page_title, "Listing All User scores")
      |> assign(:users, Accounts.list_of_users())
      |> assign(:player_score, 0)
      |> assign(:user_id, 0)
      |> assign(:workout_templates, WorkoutTemplates.list_workout_templates())

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="p-6 mb-8 bg-blue-100 rounded-lg shadow-lg scoreboard">
      <h1 class="mb-4 text-3xl text-center font-poppins">Scoreboard</h1>

      <div class="grid grid-cols-1 gap-4 md:grid-cols-3">
        <% users_have_some_player_score = Enum.reject(@users, fn each -> each.player_score == 0 end) %>
        <% user_by_order_score = Enum.sort_by(users_have_some_player_score, &(-&1.player_score)) %>
        <% rank = Enum.with_index(user_by_order_score) %>
        <%= for {user, rank} <- rank do %>
          <div class="relative bg-white rounded-lg shadow-lg ">
            <%= if rank == 0 do %>
              <p class="pt-2 pb-2 pl-4 text-yellow-500 hover:text-yellow-600 text-bold">
                #Rank <%= rank + 1 %><svg
                  class="w-10 h-14 pr-0.5 mr-0 fill-current"
                  fill="#000000"
                  height="200px"
                  width="200px"
                  version="1.1"
                  xmlns="http://www.w3.org/2000/svg"
                  xmlns:xlink="http://www.w3.org/1999/xlink"
                  viewBox="0 0 324.701 324.701"
                  xml:space="preserve"
                ><g stroke-width="0"></g><g stroke-linecap="round" stroke-linejoin="round"></g><g> <path d="M242.538,154.438c12.071-1.032,22.667-6.11,31.544-15.153c30.51-31.08,29.583-100.347,29.529-103.28 c-0.1-5.447-4.543-9.81-9.992-9.814l-50.269-0.033V5c0-2.762-2.239-5-5-5h-152c-2.761,0-5,2.238-5,5v21.156L31.082,26.19 c-5.448,0.004-9.891,4.367-9.992,9.814c-0.055,2.934-0.981,72.2,29.529,103.28c8.877,9.043,19.474,14.121,31.544,15.153 c4.617,32.323,28.831,58.395,60.188,65.782v62.933h-25.333c-1.635,0-3.166,0.799-4.101,2.14l-22,31.549 c-1.066,1.528-1.193,3.522-0.331,5.174c0.861,1.651,2.57,2.686,4.433,2.686c0,0,134.678-0.001,134.686,0c2.761,0,5-2.238,5-5 c0-1.21-0.507-2.195-1.145-3.184l-21.774-31.226c-0.935-1.341-2.466-2.14-4.101-2.14h-25.333V220.22 C213.707,212.832,237.921,186.761,242.538,154.438z M283.457,46.183c-0.965,22.133-6.193,61.311-23.647,79.091 c-4.822,4.911-10.247,7.849-16.459,8.91V46.156L283.457,46.183z M41.253,46.183l40.097-0.026v88.027 c-6.207-1.061-11.626-3.991-16.444-8.894C47.486,107.563,42.236,68.339,41.253,46.183z M120.917,83.455l28.63-4.16l12.804-25.943 l12.804,25.943l28.63,4.16l-20.717,20.194l4.891,28.515l-25.607-13.463l-25.607,13.463l4.891-28.515L120.917,83.455z"></path> </g></svg>
              </p>
            <% else %>
              <%= if rank == 1 do %>
                <p class="pt-2 pb-2 pl-4 text-base text-zinc-400 hover:text-zinc-600">
                  #Rank <%= rank + 1 %><svg
                    class="w-10 h-14 pr-0.5 mr-0 fill-current"
                    fill="#000000"
                    height="200px"
                    width="200px"
                    version="1.1"
                    xmlns="http://www.w3.org/2000/svg"
                    xmlns:xlink="http://www.w3.org/1999/xlink"
                    viewBox="0 0 324.701 324.701"
                    xml:space="preserve"
                  ><g stroke-width="0"></g><g stroke-linecap="round" stroke-linejoin="round"></g><g> <path d="M242.538,154.438c12.071-1.032,22.667-6.11,31.544-15.153c30.51-31.08,29.583-100.347,29.529-103.28 c-0.1-5.447-4.543-9.81-9.992-9.814l-50.269-0.033V5c0-2.762-2.239-5-5-5h-152c-2.761,0-5,2.238-5,5v21.156L31.082,26.19 c-5.448,0.004-9.891,4.367-9.992,9.814c-0.055,2.934-0.981,72.2,29.529,103.28c8.877,9.043,19.474,14.121,31.544,15.153 c4.617,32.323,28.831,58.395,60.188,65.782v62.933h-25.333c-1.635,0-3.166,0.799-4.101,2.14l-22,31.549 c-1.066,1.528-1.193,3.522-0.331,5.174c0.861,1.651,2.57,2.686,4.433,2.686c0,0,134.678-0.001,134.686,0c2.761,0,5-2.238,5-5 c0-1.21-0.507-2.195-1.145-3.184l-21.774-31.226c-0.935-1.341-2.466-2.14-4.101-2.14h-25.333V220.22 C213.707,212.832,237.921,186.761,242.538,154.438z M283.457,46.183c-0.965,22.133-6.193,61.311-23.647,79.091 c-4.822,4.911-10.247,7.849-16.459,8.91V46.156L283.457,46.183z M41.253,46.183l40.097-0.026v88.027 c-6.207-1.061-11.626-3.991-16.444-8.894C47.486,107.563,42.236,68.339,41.253,46.183z M120.917,83.455l28.63-4.16l12.804-25.943 l12.804,25.943l28.63,4.16l-20.717,20.194l4.891,28.515l-25.607-13.463l-25.607,13.463l4.891-28.515L120.917,83.455z"></path> </g></svg>
                </p>
              <% else %>
                <%= if rank == 2 do %>
                  <p class="pt-2 pb-2 pl-4 text-base text-amber-700 hover:text-amber-800">
                    #Rank <%= rank + 1 %><svg
                      class="w-10 h-14 pr-0.5 mr-0 fill-current"
                      fill="#000000"
                      height="200px"
                      width="200px"
                      version="1.1"
                      xmlns="http://www.w3.org/2000/svg"
                      xmlns:xlink="http://www.w3.org/1999/xlink"
                      viewBox="0 0 324.701 324.701"
                      xml:space="preserve"
                    ><g stroke-width="0"></g><g stroke-linecap="round" stroke-linejoin="round"></g><g> <path d="M242.538,154.438c12.071-1.032,22.667-6.11,31.544-15.153c30.51-31.08,29.583-100.347,29.529-103.28 c-0.1-5.447-4.543-9.81-9.992-9.814l-50.269-0.033V5c0-2.762-2.239-5-5-5h-152c-2.761,0-5,2.238-5,5v21.156L31.082,26.19 c-5.448,0.004-9.891,4.367-9.992,9.814c-0.055,2.934-0.981,72.2,29.529,103.28c8.877,9.043,19.474,14.121,31.544,15.153 c4.617,32.323,28.831,58.395,60.188,65.782v62.933h-25.333c-1.635,0-3.166,0.799-4.101,2.14l-22,31.549 c-1.066,1.528-1.193,3.522-0.331,5.174c0.861,1.651,2.57,2.686,4.433,2.686c0,0,134.678-0.001,134.686,0c2.761,0,5-2.238,5-5 c0-1.21-0.507-2.195-1.145-3.184l-21.774-31.226c-0.935-1.341-2.466-2.14-4.101-2.14h-25.333V220.22 C213.707,212.832,237.921,186.761,242.538,154.438z M283.457,46.183c-0.965,22.133-6.193,61.311-23.647,79.091 c-4.822,4.911-10.247,7.849-16.459,8.91V46.156L283.457,46.183z M41.253,46.183l40.097-0.026v88.027 c-6.207-1.061-11.626-3.991-16.444-8.894C47.486,107.563,42.236,68.339,41.253,46.183z M120.917,83.455l28.63-4.16l12.804-25.943 l12.804,25.943l28.63,4.16l-20.717,20.194l4.891,28.515l-25.607-13.463l-25.607,13.463l4.891-28.515L120.917,83.455z"></path> </g></svg>
                  </p>
                <% else %>
                  <p class="pt-2 pb-2 pl-4 text-base text-gray-500">#Rank <%= rank + 1 %></p>
                <% end %>
              <% end %>
            <% end %>
            <div class="flex items-center justify-between px-6 py-4 border-gray-400 user-info">
              <a href="#" class="mb-2 text-2xl text-gray-600 font-poppins hover:text-lime-500">
                <%= String.upcase(user.name) %>
                <div class="absolute top-0 right-0 px-4 py-2 pt-2 text-xs font-bold text-white bg-gray-600 rounded-tr-lg rounded-bl-lg hover:text-xl">
                  @<%= user.username %>
                </div>
              </a>
            </div>
            <div class="flex justify-between ">
              <p class="pt-2 pb-2 pl-4 text-base text-orange-500">
                <%= Calendar.strftime(user.updated_at, "%B %-d, %Y") %>
              </p>
              <% user_workout_template =
                Enum.filter(@workout_templates, fn each ->
                  each.user_id == user.id and each.is_finished == true
                end) %>
              <span class="pb-2 pr-2 text-gray-500 ">
                <%= length(user_workout_template) %> ✕ workout complete
              </span>
            </div>
            <div class="flex justify-between px-4 py-2 text-white bg-gray-700 rounded-b-lg user-score">
              <%= if user.id == @user_id do %>
                <p class="text-base text-red-400 score-label font-poppins">Total Score:</p>
                <p class="text-3xl font-bold score"><%= @player_score %></p>
              <% else %>
                <p class="text-base text-red-400 score-label font-poppins">Total Score:</p>
                <p class="text-3xl font-bold score"><%= user.player_score %></p>
              <% end %>
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  @impl true
  def handle_info(
        {:update_users,
         {updated_users, update_workout_template, updated_player_score, updated_user_id}},
        socket
      ) do
    socket =
      socket
      |> assign(player_score: updated_player_score)
      |> assign(workout_templates: update_workout_template)
      |> assign(users: updated_users)
      |> assign(user_id: updated_user_id)

    {:noreply, socket}
  end
end
