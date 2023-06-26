defmodule Fitness.Accounts.UserTypes.RegularUser do
  use Ecto.Schema
  import Ecto.Changeset
  alias Fitness.Accounts.UserTypes.RegularUser

  embedded_schema do
    field :name, :string, default: "mohsin"
    field :player_score, :integer, default: 0
    field :user_image, :string, default: "/images/user-profile.svg"
  end

   @doc false
   def changeset(%RegularUser{} = regular_users, attrs \\ %{}) do
    regular_users
    |> cast(attrs, [:player_score, :user_image])
    |> validate_required([:player_score, :user_image])
  end
end
