defmodule Fitness.Accounts.UserTypes.Admin do
  use Ecto.Schema

  import Ecto.Changeset

  alias Fitness.Accounts.UserTypes.Admin

  @primary_key false
  
  embedded_schema do
    field :name, :string, default: "admin"
  end

  @doc false
  def changeset(%Admin{} = admin_users, attrs \\ %{}) do
    admin_users
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
