defmodule Hub.Question do
  use Ecto.Schema

  import Ecto.{Changeset, Query}

  alias Hub.Answer
  alias __MODULE__

  schema "questions" do
    field :tags, {:array, :string}
    field :text, :string
    field :created_by, :string
    belongs_to :solution, Answer
    has_many :answers, Answer

    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:text, :tags, :created_by])
    |> validate_required([:text, :tags, :created_by])
  end

  def where_has_tags(query \\ Question, tags)

  def where_has_tags(query, tags) when not is_list(tags) do
    where_has_tags(query, List.wrap(tags))
  end

  def where_has_tags(query, tags) do
    where(query, [q],  fragment("? :: text[] && ?", q.tags, ^tags))
  end
end
