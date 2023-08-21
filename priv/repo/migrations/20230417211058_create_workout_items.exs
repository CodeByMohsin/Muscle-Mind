defmodule Fitness.Repo.Migrations.CreateWorkoutItems do
  use Ecto.Migration

  def change do
    create table(:workout_items) do
      add :sets, :integer
      add :weight, :float
      add :weight_unit, :string
      add :reps, :integer
      add :check_box, :boolean, default: false, null: false
      add :exercise_id, references(:exercises, on_delete: :delete_all), null: false

      add :workout_template_id, references(:workout_templates, on_delete: :delete_all),
        null: false

      timestamps()
    end

    create index(:workout_items, [:exercise_id])
    create index(:workout_items, [:workout_template_id])
  end
end
