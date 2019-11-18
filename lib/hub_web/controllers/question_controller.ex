defmodule HubWeb.QuestionController do
  use HubWeb.ResourceController, for: HubDB.Question, camelize?: true

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
  def resource_s(type) do
    s =
      schema(%{
        "id" => spec(is_integer() and (&(&1 > 0))),
        "text" =>
          with_gen(
            spec(is_binary() and fn str -> String.length(str) > 0 end),
            StreamData.string(:printable, min_length: 1)
          ),
        "tags" =>
          with_gen(
            spec(is_list() and fn tags -> Enum.all?(tags, &is_binary/1) end),
            StreamData.list_of(StreamData.string(:printable, min_length: 1))
          ),
        "createdBy" =>
          with_gen(
            spec(is_binary() and fn str -> String.length(str) > 0 end),
            StreamData.string(:printable, min_length: 1)
          )
      })

    case type do
      :create -> selection(s, ["text", "tags", "createdBy"])
      :update -> selection(s, ["text", "tags"])
      _ -> s
    end
  end
end
