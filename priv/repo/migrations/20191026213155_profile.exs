defmodule HubPersistence.Repo.Migrations.CreateProfiles do
  use Ecto.Migration

  def change do
    create table(:profiles) do
      add :name, :string
      add :cohort, :string
      add :tags, {:array, :string}
      add :bio, :string
      add :userId, :string

      timestamps()
    end
  end
end
