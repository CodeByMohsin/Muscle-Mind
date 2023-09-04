defmodule FitnessWeb.ChatLive do
  use FitnessWeb, :live_view

  alias Fitness.Chats

  @impl true
  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user

    rooms = Chats.list_rooms()

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
      |> assign(rooms: rooms)
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

    html = Earmark.as_html!(params["data"]) |> HtmlSanitizeEx.markdown_html()

    IO.inspect(html)

    case Chats.create_message(Map.merge(params, %{"data" => html})) do
      {:ok, _message} ->
        {:noreply, assign(socket, messages: Chats.list_message(socket.assigns.room.id))}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <section class="w-full h-[calc(100%-20rem)]">
      <h1 class="fixed w-full bg-[#232323] text-2xl text-center py-6 text-white drop-shadow-2xl">
        # <%= @room.name %>
      </h1>

      <div class="w-full h-[50rem] flex flex-col gap-4 pt-36 pb-24 pl-12 bg-[#6b6a6a] overflow-auto scroll-none">
        <div
          :for={message <- @messages}
          id="messages_card"
          phx-update="stream"
          class="card bg-yellow-100 w-11/12"
        >
          <%= raw(message.data) %>

          <%= message.inserted_at %>
          <%= message.user.username %>
        </div>
      </div>
      <.form
        :let={f}
        for={@changeset}
        phx-submit="create"
        id="easy_text_editor_form"
        phx-validate="validate"
      >

        <div class="fixed z-10 bottom-0 w-[100%] bg-yellow-100">
          <div id="rich-text-editor" phx-update="ignore">
            <%= textarea(f, :data,
              id: "rich_text_input",
              phx_hook: "easyMDE",
              class: "hidden"
            ) %>
          </div>

            <button type="submit" id="easy_text_editor_submit" class="absolute right-[7rem] bottom-4 z-50">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="yellow"
                viewBox="0 0 24 24"
                stroke-width="1.5"
                stroke="currentColor"
                class="w-8 h-8"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  d="M6 12L3.269 3.126A59.768 59.768 0 0121.485 12 59.77 59.77 0 013.27 20.876L5.999 12zm0 0h7.5"
                />
              </svg>
            </button>
          </div>
      </.form>
    </section>
    """
  end
end
