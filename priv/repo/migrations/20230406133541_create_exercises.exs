defmodule Fitness.Repo.Migrations.CreateExercises do
  use Ecto.Migration

  def change do
    create table(:exercises) do
      add :name, :string
      add :description, :text
      add :gif_url, :string
      add :level, :string
      add :type, :string

      timestamps()
    end
  end
end
