defmodule FitnessWeb.ChatLive do
  use FitnessWeb, :live_view

  alias Fitness.Chats

  @impl true
  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user

    room = hd(Chats.list_rooms())

    changeset =
      Chats.change_message(%{
        room_id: room.id,
        user_id: current_user.id,
        data: ""
      })

    socket =
      socket
      |> assign(changeset: changeset)
      |> assign(room: room)
      |> assign(current_user: current_user)
      |> assign(messages: Chats.list_message(room.id))

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"message" => _params}, socket) do
    # IO.inspect(params)
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
      {:ok, _message} ->
        {:noreply, assign(socket, messages: Chats.list_message(socket.assigns.room.id))}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <section class="flex w-full">
      <div class="w-[15%] h-full border-r-2 border-gray-800-500">
        <h1 class="text-2xl font-[700] pt-8 pl-4 rounded-r-sm text-gray-700">
          Channels
        </h1>
        <div class="pt-4 pl-5 flex flex-col justify-between">
          <h3> <strong>#</strong> fitness club1</h3>
          <h3> <strong>#</strong> fitness club2</h3>
          <h3> <strong>#</strong> fitness club3</h3>
        </div>
      </div>

      <div class="w-[85%] relative">
        <h1 class="w-[100%] bg-yellow-200 pl-7 text-3xl py-3 text-gray-700 drop-shadow-md border-b-2">
          <%= "# #{@room.name}" %>
        </h1>

        <div class="flex flex-col justify-evenly pl-8">
          <div
            :for={message <- @messages}
            id="messages_card"
            phx-update="stream"
            class="card bg-yellow-100 w-[90%]"
          >
            <%= message.data %>
            <%= message.inserted_at %>
            <%= message.user.username %>
          </div>
          <%!-- <.form
            :let={f}
            for={@changeset}
            phx-submit="create"
            id="easy_text_editor_form"
            phx-validate="validate"
          >
            <div class="relative">
              <div id="rich-text-editor">
                <%= textarea(f, :data,
                  id: "rich_text_input",
                  phx_hook: "easyMDE",
                  phx_update: "ignore",
                  class: "hidden"
                ) %>
              </div>

              <button
                type="submit"
                id="easy_text_editor_submit"
                class="absolute right-1 bottom-10 z-2"
              >
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  fill="red"
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
            </div>
          </.form> --%>
        </div>
      </div>
    </section>
    """
  end
end
