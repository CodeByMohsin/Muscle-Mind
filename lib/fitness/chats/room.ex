defmodule Fitness.Chats.Schema.Room do
  use Ecto.Schema
  import Ecto.Changeset

  alias Fitness.Chats.Schema.Message

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "rooms" do
    field :name, :string
    field :visibilty, Ecto.Enum, values: [:public, :private], default: :public

    has_many :messages, Message

    timestamps()
  end

  def changeset(room, attrs \\ %{}) do
    room
    |> cast(attrs, [:name, :visibilty])
    |> validate_required([:name, :visibilty])
  end
end
