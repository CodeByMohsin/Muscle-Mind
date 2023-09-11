defmodule Fitness.Repo.Migrations.AddMessagesInsertedAtIndex do
  use Ecto.Migration

  @disable_ddl_transaction true
  @disable_migration_lock true

  def change do
    create index("messages", ["inserted_at DESC"], concurrently: true)
  end
end
