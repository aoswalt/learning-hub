defmodule HubDB.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :text, primary_key: true

      timestamps()
    end
  end
end
