defmodule Fitness.Repo.Migrations.AddAccountTypeToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :name, :string, null: false
      add :player_score, :integer, default: 0, null: false
      add :username, :citext, null: false
      add :image, :string, default: "/images/user-profile.svg", null: false
      add :account_type, :string, null: false
      add :regular_user, :map
    end

    create unique_index(:users, [:username])
  end
end
