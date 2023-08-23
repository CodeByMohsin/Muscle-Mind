defmodule Fitness.Repo.Migrations.AddRoomTable do
  use Ecto.Migration

  def change do
    create table(:rooms, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :visibility, :string
      timestamps()
    end
  end
end
