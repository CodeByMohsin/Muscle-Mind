defmodule Fitness.Chats.Schema.Message do
  use Ecto.Schema
  import Ecto.Changeset

  alias Fitness.Accounts.User
  alias Fitness.Chats.Schema.Room

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "messages" do
    field(:data, :string)
    belongs_to(:user, User, type: :integer)
    belongs_to(:room, Room, type: :binary_id)

    timestamps()
  end

  def changeset(message, attrs \\ %{}) do
    message
    |> cast(attrs, [:data, :user_id, :room_id])
    |> validate_required([:data, :user_id, :room_id])
  end
end
