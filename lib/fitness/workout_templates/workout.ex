defmodule Fitness.WorkoutTemplates.Workout do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workouts" do
    field :check_box, :boolean, default: false
    field :set, :integer
    field :weight, :integer
    field :weight_unit, :string
    field :exercise_id, :id

    timestamps()
  end

  @doc false
  def changeset(workout, attrs) do
    workout
    |> cast(attrs, [:set, :weight, :weight_unit, :check_box])
    |> validate_required([:set, :weight, :weight_unit, :check_box])
  end
end
