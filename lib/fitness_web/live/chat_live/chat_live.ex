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
  def handle_event("change", params, socket) do
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

    <div :for={message <- @messages} id={message.id}>
      <%= message.data %>
      <%= message.inserted_at %>
      <%= message.user.username %>
    </div>

    <div class=" relative mt-10">
      <.form
        :let={f}
        for={@changeset}
        phx-submit="create"
        id="easy_text_editor_form"
        phx-validate="validate"
      >
        <div id="rich-text-editor">
          <%= textarea(f, :data,
            id: "rich_text_input",
            phx_hook: "easyMDE",
            phx_update: "ignore",
            class: "hidden"
          ) %>
        </div>

        <button type="submit" id="easy_text_editor_submit" class="absolute right-1 bottom-10 ">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            stroke-width="1.5"
            stroke="currentColor"
            class="w-6 h-6"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              d="M6 12L3.269 3.126A59.768 59.768 0 0121.485 12 59.77 59.77 0 013.27 20.876L5.999 12zm0 0h7.5"
            />
          </svg>
        </button>
      </.form>
    </div>
    """
  end
end
