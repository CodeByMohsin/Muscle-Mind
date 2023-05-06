defmodule FitnessWeb.ScoreBoardLive do
  use FitnessWeb, :live_view



  def mount(params, session, socket) do
    socket =
      socket
      |> assign(:page_title, "Listing All User scores")
   {:ok, socket}
  end

  def render(assigns) do
~H"""

<h1>hello from score board live</h1>

"""
  end

end
