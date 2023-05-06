defmodule FitnessWeb.WorkoutTemplateLive.ActivityHistory do
  use FitnessWeb, :live_view

  alias Fitness.WorkoutTemplates
  alias Fitness.WorkoutTemplates.WorkoutTemplate
  alias Fitness.Accounts

  @impl true
  def mount(_params, session, socket) do
    if session["user_token"] do
      cond do
        Accounts.get_user_by_session_token(session["user_token"]) == nil ->
          {:ok, assign(socket, workout_templates: list_workout_templates())}

        Accounts.get_user_by_session_token(session["user_token"]) ->
          user = Accounts.get_user_by_session_token(session["user_token"])
          is_admin = Accounts.is_admin?(user)

          {:ok, assign(socket, workout_templates: list_workout_templates(), is_admin: is_admin, user: user)}
      end
    else
      {:ok, assign(socket, workout_templates: list_workout_templates())}
    end
  end

  @impl true
  def render(assigns) do
~H"""

<div class="bg-blue-100 shadow-lg p-6 mb-8">
  <h1 class="flex justify-center pt-0 items-center text-4xl mb-4 font-poppins">History</h1>


  <%= if assigns[:user] do %>
        <%= if length(@workout_templates) >= 1 do %>
      <% user_template_owner = Enum.at(@workout_templates,-1) %>

      <%= if assigns[:user].id == user_template_owner.user_id do %>
      <% workout_template_are_finished = Enum.filter(@workout_templates, fn each -> each.is_finished == true end) %>
      <div class="flex justify-end mb-4">
      <p class="bg-yellow-500 hover:bg-yellow-700 font-poppins hover:text-2xl text-white px-2 py-1 text-xl rounded-full text-sm"><%= length(workout_template_are_finished) %> Workouts</p>
      </div>
      <div class="grid gap-4 grid-cols-2">
      <%= for workout_template <- Enum.reverse(workout_template_are_finished) do %>
        <div id={"workout_template-#{workout_template.id}"}, class="bg-white rounded-lg shadow-lg relative">

          <div class="flex justify-between px-6 py-4  rounded  border-gray-400">

          <p class="text-orange-500 text-base"><%= Calendar.strftime(workout_template.updated_at, "%B %-d, %Y") %></p>
            <a href={"/workout_templates/#{workout_template.id}"} class="font-poppins text-xl text-gray-700 mb-2"><%= String.upcase(workout_template.name) %> </a>
            <span class="bg-gray-600 hover:bg-gray-700 font-poppins  text-white px-2 py-1 text-xl rounded-full text-sm">Score: <%= workout_template.workout_template_score %></span>

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
      <% end %>
    <% end %>
  </div>

"""
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :history, params) do


    list_of_workout_template_is_finish = Enum.filter(socket.assigns.workout_templates, fn each -> each.is_finished == true end)
    user_id = socket.assigns.current_user.id
    user = Accounts.get_user!(user_id)
    player_score = user.player_score

    total_workout_template_score = Enum.reduce(list_of_workout_template_is_finish, 0, fn each, acc -> acc + each.workout_template_score end )

     Accounts.update_user_player_score(user, %{"player_score" => "#{total_workout_template_score}"})


    preload_workout_template =

    for each_workout_template<- socket.assigns.workout_templates do
      WorkoutTemplates.get_workout_template!(each_workout_template.id)
    end

    socket
    |> assign(:page_title, "Listing Workout templates")
    |> assign(:workout_templates, preload_workout_template)
  end



  defp list_workout_templates do
    WorkoutTemplates.list_workout_templates()
  end

end
