defmodule Fitness.Repo.Migrations.CreateWorkoutTemplates do
  use Ecto.Migration

  def change do
    create table(:workout_templates) do
      add :name, :string

      timestamps()
    end
  end
end
