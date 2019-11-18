defmodule HubWeb.AnswerController do
  use HubWeb.ResourceController, for: HubDB.Answer

  import Norm

  @impl HubWeb.ResourceController
  def resource_s(type \\ nil) do
    s =
      schema(%{
        "id" => spec(is_integer() and (&(&1 > 0))),
        "questionId" => spec(is_integer() and (&(&1 > 0))),
        "text" =>
          with_gen(
            spec(is_binary() and fn str -> String.length(str) > 0 end),
            StreamData.string(:printable, min_length: 1)
          ),
        "createdBy" =>
          with_gen(
            spec(is_binary() and fn str -> String.length(str) > 0 end),
            StreamData.string(:printable, min_length: 1)
          ),
        "createdAt" =>
          with_gen(
            spec(&match?(%NaiveDateTime{}, &1)),
            HubDB.Spec.Generators.naive_datetime()
          )
      })

    case type do
      :create -> selection(s, ["text", "questionId", "createdBy"])
      :update -> selection(s, ["text"])
      _ -> s
    end
  end

  @impl HubWeb.ResourceController
  def to_serializable(answer) do
    %{
      "id" => answer.id,
      "text" => answer.text,
      "questionId" => answer.question_id,
      "createdAt" => answer.inserted_at,
      "createdBy" => answer.created_by
    }
  end
end
