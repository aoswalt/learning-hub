defmodule HubWeb.QuestionController do
  use HubWeb.ResourceController, for: HubDB.Question, camelize?: true

  import Hub.Spec
  import Norm

  alias HubDB.Question

  # 2-arity - query, params
  # nil is non-filterable
  @impl HubWeb.ResourceController
  def filter_overrides(), do: %{
    "tags" => &Question.where_has_tags(&1, &2)
  }

  # filter "tags", &Question.where_has_tags(&1, &2)
  # param "tags", &Question.where_has_tags(&1, &2)

  # one of serializable_fields, to_serializable, or derive Jason
  # or camelize?: true
  # def serializable_fields(), do: [:id, :text, :tags, :created_by]

  # @impl ResourceController
  # def to_serializable(question) do
  #   %{
  #     "id" => question.id,
  #     "text" => question.text,
  #     "tags" => question.tags,
  #     "createdBy" => question.created_by
  #   }
  # end

  @impl HubWeb.ResourceController
  def resource_s(type \\ nil) do
    s =
      schema(%{
        "id" => positive_integer(),
        "text" => nonempty_string(),
        "tags" => coll_of(nonempty_string(), min_count: 1),
        "createdBy" => nonempty_string()
      })

    case type do
      :create -> selection(s, ["text", "tags", "createdBy"])
      :update -> selection(s, ["text", "tags"])
      _ -> s
    end
  end
end
