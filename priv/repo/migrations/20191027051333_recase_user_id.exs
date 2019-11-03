defmodule HubPersistence.Repo.Migrations.RecaseUserId do
  use Ecto.Migration

  def change do
    rename table(:profiles), :userId, to: :user_id
  end
end
