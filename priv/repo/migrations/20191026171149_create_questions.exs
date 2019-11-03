defmodule HubPersistence.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add :tags, {:array, :string}
      add :text, :text
      add :created_by, :string

      timestamps()
    end
  end
end
