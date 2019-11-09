defmodule HubDB.Repo.Migrations.CreateProfiles do
  use Ecto.Migration

  def change do
    create table(:profiles) do
      add :name, :text
      add :cohort, :text
      add :tags, {:array, :text}
      add :bio, :text
      add :user_id, :text

      timestamps()
    end
  end
end
