defmodule Fitness.Chats do
  import Ecto.Query

  alias Fitness.Repo

  alias Fitness.Chats.Schema.{Message, Room}

  def create_room(attrs \\ %{}) do
    %Room{}
    |> Room.changeset(attrs)
    |> Repo.insert()
  end

  def list_message(room_id) do
    from(m in Message,
      where: m.room_id == ^room_id,
      order_by: [asc: m.inserted_at],
      preload: [:users]
    )
    |> Repo.all()
  end

  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  def update_message(%Message{} = message, attrs \\ %{}) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  def change_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
  end
end
