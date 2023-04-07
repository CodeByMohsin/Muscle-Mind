defmodule Fitness.Exercises.Exercise do
  use Ecto.Schema
  import Ecto.Changeset

  schema "exercises" do
    field :description, :string
    field :gif_url, :string
    field :level, :string
    field :name, :string
    field :type, :string

    timestamps()
  end

  @doc false
  def changeset(exercise, attrs) do
    exercise
    |> cast(attrs, [:name, :description, :gif_url, :level, :type])
    |> validate_required([:name])
  end
end
