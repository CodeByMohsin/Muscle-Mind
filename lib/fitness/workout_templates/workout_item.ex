defmodule Fitness.WorkoutTemplates.WorkoutItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workout_items" do
    field :check_box, :boolean, default: false
    field :set, :integer
    field :weight, :integer
    field :weight_unit, :string
    field :reps, :integer
    field :exercise_id, :id
    belongs_to :workout_template, Fitness.WorkoutTemplates.WorkoutTemplate

    timestamps()
  end

  @doc false
  def changeset(workout, attrs) do
    workout
    |> cast(attrs, [:set, :weight, :weight_unit, :check_box])
    |> validate_required([:set, :weight, :weight_unit, :check_box])
  end
end
