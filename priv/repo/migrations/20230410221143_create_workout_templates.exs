defmodule Fitness.Repo.Migrations.CreateWorkoutTemplates do
  use Ecto.Migration

  def change do
    create table(:workout_templates) do
      add :name, :string
      add :workout_template_score, :integer, default: 0
      add :is_finished, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:workout_templates, [:user_id])
  end
end
