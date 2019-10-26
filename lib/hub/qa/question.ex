defmodule Hub.QA.Question do
  use Ecto.Schema

  import Ecto.Changeset

  alias Hub.QA.Answer

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
end
