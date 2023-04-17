defmodule Fitness.Repo.Migrations.CreateWorkoutTemplates do
  use Ecto.Migration

  def change do
    create table(:workout_templates) do
      add :name, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:workout_templates, [:user_id])
  end
end
