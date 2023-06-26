defmodule Fitness.Repo.Migrations.AddAccountTypeToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :name, :string, null: false
      add :player_score, :integer, default: 0, null: false
      add :username, :citext, null: false
      add :image, :string, default: "/images/user-profile.svg", null: false
      add :account_type, :map
    end

    create unique_index(:users, [:username])
  end
end
