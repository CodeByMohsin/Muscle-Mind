defmodule Fitness.Chats.Helpers do
  alias Earmark
  alias HtmlSanitizeEx

  def to_html!(markdown) do
    markdown |> Earmark.as_html!()
  end

  def santize_message(html) do
    html
    |> HtmlSanitizeEx.markdown_html()
  end
end
