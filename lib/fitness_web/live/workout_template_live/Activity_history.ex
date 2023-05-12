defmodule FitnessWeb.WorkoutTemplateLive.ActivityHistory do
  use FitnessWeb, :live_view

  alias Fitness.WorkoutTemplates
  alias Fitness.Accounts

  @impl true
  def mount(_params, _session, socket) do
  {:ok, assign(socket, workout_templates: list_workout_templates())}
  end

  @impl true
  def render(assigns) do
~H"""

<div class="bg-blue-100 shadow-lg p-6 mb-8">
  <h1 class="flex justify-center pt-0 items-center text-4xl mb-4 font-poppins">History</h1>

        <%= if length(@workout_templates) >= 1 do %>
      <% user_template_owner = Enum.filter(@workout_templates, fn each -> each.user_id == assigns[:current_user].id end) %>


      <% workout_template_are_finished = Enum.filter(user_template_owner, fn each -> each.is_finished == true end) %>
      <div class="flex justify-end mb-4">
      <p class="relative px-6 py-4 font-poppins text-white rounded-lg hover:text-xl group">
      <span class="absolute inset-0 w-full h-full transition duration-300 transform -translate-x-1 -translate-y-1 bg-purple-800 ease opacity-80 group-hover:translate-x-0 group-hover:translate-y-0"></span>
      <span class="absolute inset-0 w-full h-full transition duration-300 transform translate-x-1 translate-y-1 bg-pink-800 ease opacity-80 group-hover:translate-x-0 group-hover:translate-y-0 mix-blend-screen"></span>
      <span class="relative"><%= length(workout_template_are_finished) %> Workouts</span>
      </p>
      </div>
      <div class="grid gap-4 grid-cols-2">
      <%= for workout_template <- Enum.reverse(workout_template_are_finished) do %>
        <div id={"workout_template-#{workout_template.id}"}, class="bg-white rounded-lg shadow-lg relative">

          <div class="flex justify-between px-6 py-4  rounded  border-gray-400">

          <p class="text-orange-500 text-base"><%= Calendar.strftime(workout_template.updated_at, "%B %-d, %Y") %></p>
            <a href={"/workout_templates/#{workout_template.id}"} class="font-poppins text-xl text-gray-700 mb-2"><%= String.upcase(workout_template.name) %> </a>
            <p class="relative inline-flex font-poppins text-xl items-center justify-start px-6 py-3 overflow-hidden font-medium transition-all bg-white rounded hover:bg-white group">
            <span class="w-48 h-48 rounded rotate-[-40deg] bg-purple-600 absolute bottom-0 left-0 -translate-x-full ease-out duration-500 transition-all translate-y-full mb-9 ml-9 group-hover:ml-0 group-hover:mb-32 group-hover:translate-x-0"></span>
            <span class="relative w-full text-left text-black transition-colors duration-300 ease-in-out group-hover:text-white">Score: <%= workout_template.workout_template_score %></span>
            </p>
          </div>
          <% list_of_same_exercise = Enum.group_by(workout_template.workout_items, fn each -> each.exercise_id end) |> Map.values() %>
          <%= for each_list <- list_of_same_exercise do %>
          <% [workout_item_map | _] = each_list %>
          <% each_list = Enum.filter(each_list, fn each -> each.check_box == true end) %>
          <div class="pb-1">
            <span class="text-gray-500 text-base pt-4 pl-6 mr-2"><%= length(each_list) %> ✕ <%= Fitness.Exercises.get_exercise!(workout_item_map.exercise_id).name %> (<%= Fitness.Exercises.get_exercise!(workout_item_map.exercise_id).body_part %>)</span>
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

    # update player_score in database
    user = socket.assigns.current_user

    list_of_workout_template_is_finish = Enum.filter(socket.assigns.workout_templates, fn each -> each.is_finished == true end)
    list_of_workout_templates_is_belong_to_user = Enum.filter(list_of_workout_template_is_finish, fn each -> each.user_id == user.id end)

    total_workout_template_score = Enum.reduce(list_of_workout_templates_is_belong_to_user, 0, fn each, acc -> acc + each.workout_template_score end )

     Accounts.update_user_player_score(user, %{"player_score" => "#{total_workout_template_score}"})

    update_users = Accounts.list_of_users()
    update_workout_template = WorkoutTemplates.list_workout_templates()
    update_user_id = Accounts.get_user!(user.id)

    Enum.each(20..update_user_id.player_score, fn each ->
      broadcast_score_board(update_users, update_workout_template, each, user.id)
      end)


    preload_workout_template =

    for each_workout_template<- socket.assigns.workout_templates do
      WorkoutTemplates.get_workout_template!(each_workout_template.id)
    end

    socket
    |> assign(:page_title, "Listing Activity History")
    |> assign(:workout_templates, preload_workout_template)
  end

  defp broadcast_score_board(updated_users, update_workout_template, updated_player_score, user_id) do
    Phoenix.PubSub.broadcast(Fitness.PubSub, "score_board", {:update_users, {updated_users, update_workout_template, updated_player_score, user_id}})
  end

  defp list_workout_templates do
    WorkoutTemplates.list_workout_templates()
  end

end
