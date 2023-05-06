defmodule Fitness.Repo.Migrations.AddAdminFieldInUsersAuthSchema do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :is_admin, :boolean, default: false, null: false
      add :name, :string
      add :player_score, :integer, default: 0
      add :username, :citext, null: false
    end

    create unique_index(:users, [:username])
  end
end
