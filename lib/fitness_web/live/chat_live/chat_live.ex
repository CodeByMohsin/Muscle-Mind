defmodule FitnessWeb.ChatLive do
  use FitnessWeb, :live_view

  alias Fitness.Chats
  alias Fitness.Repo

  @impl true
  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user

    changeset =
      Chats.change_message(%{
        room_id: "8c30bb29-1aa2-4af2-8091-70032c1a9ffa",
        user_id: current_user.id,
        data: ""
      })

    default_room = Repo.get(Fitness.Chats.Schema.Room, "8c30bb29-1aa2-4af2-8091-70032c1a9ffa")



    socket =
      socket
      |> assign(changeset: changeset)
      |> assign(room: default_room)
      |> assign(current_user: current_user)
      |> assign(messages: Chats.list_message(default_room.id))

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"message" => params}, socket) do
    IO.inspect(params)
    {:noreply, socket}
  end

  @impl true
  def handle_event("create", %{"message" => params}, socket) do
    params =
      params
      |> Map.put("user_id", socket.assigns.current_user.id)
      |> Map.put("room_id", socket.assigns.room.id)

    case Chats.create_message(params) do
      {:ok, message} ->
        {:noreply, assign(socket, messages: Chats.list_message(socket.assigns.room.id))}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1>Room: <%= @room.name %></h1>

    <div :for={message <- @messages} id="messages_card" phx-update="stream">
      <%= message.data %>
      <%= message.inserted_at %>
      <%= message.user.username %>
    </div>

    <.form :let={f} for={@changeset} phx-change="validate" phx-submit="create">
      <%= text_input(f, :data, class: "w-max") %>
      <button class="block" type="create">Save</button>
    </.form>
    """
  end
end
