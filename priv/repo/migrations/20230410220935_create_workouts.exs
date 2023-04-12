defmodule Fitness.Repo.Migrations.CreateWorkouts do
  use Ecto.Migration

  def change do
    create table(:workouts) do
      add :set, :integer
      add :weight, :integer
      add :weight_unit, :string
      add :check_box, :boolean, default: false, null: false
      add :exercise_id, references(:exercises, on_delete: :nothing)

      timestamps()
    end

    create index(:workouts, [:exercise_id])
  end
end
