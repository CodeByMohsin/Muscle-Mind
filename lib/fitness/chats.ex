defmodule Fitness.Chats do
  import Ecto.Query

  alias Fitness.Repo

  alias Fitness.Chats.Schema.{Message, Room}

  def create_room(attrs \\ %{}) do
    %Room{}
    |> Room.changeset(attrs)
    |> Repo.insert()
  end

  def list_rooms do
    Repo.all(Room)
  end

  def get_room(room_id), do: Repo.get(Room, room_id)

  # change it to keyset pagination
  def list_messages(room_id, opts) do
    Message
    |> where([m], m.room_id == ^room_id)
    |> order_by([m], desc: m.inserted_at)
    |> limit(^opts[:limit])
    |> offset(^opts[:offset])
    |> preload([:user])
    |> select([m], m)
    |> Repo.all()
  end

  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, struct} ->
        struct
        |> Repo.preload(:user)
        |> broadcast_new_message()

        {:ok, struct}

      error ->
        error
    end
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

  defp broadcast_new_message(message) do
    Phoenix.PubSub.broadcast!(Fitness.PubSub, "new_message", {:new_message, message})
    message
  end
end
