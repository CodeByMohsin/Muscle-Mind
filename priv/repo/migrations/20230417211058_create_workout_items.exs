defmodule Fitness.Repo.Migrations.CreateWorkoutItems do
  use Ecto.Migration

  def change do
    create table(:workout_items) do
      add :set, :integer
      add :weight, :integer
      add :weight_unit, :string
      add :reps, :integer
      add :check_box, :boolean, default: false, null: false
      add :exercise_id, references(:exercises, on_delete: :nothing)
      add :workout_template_id, references(:workout_templates, on_delete: :nothing)

      timestamps()
    end

    create index(:workout_items, [:exercise_id])
    create index(:workout_items, [:workout_template_id])
  end
end
