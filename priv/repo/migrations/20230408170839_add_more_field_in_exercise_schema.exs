defmodule Fitness.Repo.Migrations.AddMoreFieldInExerciseSchema do
  use Ecto.Migration

  def change do
    alter table(:exercises) do
      add :body_part, :string
      add :equipment, :string
    end

  end
end
