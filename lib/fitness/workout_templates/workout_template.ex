defmodule Fitness.WorkoutTemplates.WorkoutTemplate do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workout_templates" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(workout_template, attrs) do
    workout_template
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
