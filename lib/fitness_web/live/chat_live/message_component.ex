defmodule FitnessWeb.MessageComponent do
  use FitnessWeb, :component

  def message_card(assigns) do
    ~H"""
    <div id="messages" phx-update="stream" class="flex flex-col gap-4 pb-14 pl-12 mt-24">
      <div :for={{id, message} <- @messages} id={id}>
        <div class="card bg-yellow-100 w-11/12">
          <%= raw(message.data) %>
          <%= present_date(message.inserted_at) %>
          <%= message.user.username %>
        </div>
      </div>
    </div>
    """
  end
end
