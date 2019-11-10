defmodule HubDB.Repo.Migrations.CreateAnswers do
  use Ecto.Migration

  def change do
    create table(:answers) do
      add :text, :text
      add :created_by, references(:users, type: :text)
      add :question_id, references(:questions)

      timestamps()
    end

    alter table(:questions) do
      add :solution_id, references(:answers)
    end
  end
end
