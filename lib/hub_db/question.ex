defmodule HubDB.Question do
  use Ecto.Schema

  import Ecto.{Changeset, Query}

  alias HubDB.{Answer, User}
  alias __MODULE__

  schema "questions" do
    field :tags, {:array, :string}
    field :text, :string
    belongs_to :created_by_user, User, foreign_key: :created_by, type: :string
    belongs_to :solution, Answer
    has_many :answers, Answer

    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:text, :tags, :created_by, :solution_id])
    |> validate_required([:text, :tags, :created_by])
    |> assoc_constraint(:created_by_user)
  end

  def solve(question, answer_id) do
    changeset(question, %{solution_id: answer_id})
  end

  def where_has_tags(query \\ Question, tags)

  def where_has_tags(query, tags) when not is_list(tags) do
    where_has_tags(query, List.wrap(tags))
  end

  def where_has_tags(query, tags) do
    where(query, [q], fragment("? && ?", q.tags, ^tags))
  end
end
