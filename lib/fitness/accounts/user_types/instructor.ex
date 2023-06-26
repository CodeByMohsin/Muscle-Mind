defmodule Fitness.Accounts.UserTypes.Instructor do
  use Ecto.Schema

  import Ecto.Changeset

  alias Fitness.Accounts.UserTypes.Instructor

  @primary_key false
  
  embedded_schema do
    field :name, :string, default: "instructor"
  end

  @doc false
  def changeset(%Instructor{} = instructor_users, attrs \\ %{}) do
    instructor_users
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
