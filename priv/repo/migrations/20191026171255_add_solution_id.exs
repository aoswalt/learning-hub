defmodule HubDB.Repo.Migrations.AddSolutionId do
  use Ecto.Migration

  def change do
    alter table(:questions) do
      add :solution_id, references(:answers)
    end
  end
end
