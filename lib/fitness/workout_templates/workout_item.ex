defmodule Fitness.WorkoutTemplates.WorkoutItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workout_items" do
    field :check_box, :boolean, default: false
    field :sets, :integer
    field :weight, :float
    field :weight_unit, :string
    field :reps, :integer
    belongs_to :exercise, Fitness.Exercises.Exercise
    belongs_to :workout_template, Fitness.WorkoutTemplates.WorkoutTemplate

    timestamps()
  end

  @doc false
  def changeset(workout, attrs) do
    workout
    |> cast(attrs, [
      :sets,
      :weight,
      :weight_unit,
      :check_box,
      :reps,
      :exercise_id,
      :workout_template_id
    ])
    |> validate_required([:sets, :weight, :weight_unit, :reps, :workout_template_id, :exercise_id])
  end
end
