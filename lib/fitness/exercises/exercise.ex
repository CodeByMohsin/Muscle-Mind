defmodule Fitness.Exercises.Exercise do
  use Ecto.Schema
  import Ecto.Changeset

  schema "exercises" do
    field :body_part, :string
    field :description, :string
    field :equipment, :string
    field :gif_url, :string
    field :level, :string
    field :name, :string
    field :type, :string
    has_many :workoutItem, Fitness.WorkoutTemplates.WorkoutItem
    timestamps()
  end

  @doc false
  def changeset(exercise, attrs) do
    exercise
    |> cast(attrs, [:name, :description, :gif_url, :level, :type, :equipment, :body_part])
    |> validate_required([:name, :level, :equipment, :body_part])
  end
end
