defmodule Fitness.Accounts.UserTypes.RegularUser do
  use Ecto.Schema

  import Ecto.Changeset

  alias Fitness.Accounts.UserTypes.RegularUser

  @primary_key false
  
  embedded_schema do
    field :name, :string, default: "regularUser"
  end

  @doc false
  def changeset(%RegularUser{} = regular_users, attrs \\ %{}) do
    regular_users
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
