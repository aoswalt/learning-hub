defmodule HubDB.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add :tags, {:array, :text}
      add :text, :text
      add :created_by, references(:users, type: :text)

      timestamps()
    end
  end
end
