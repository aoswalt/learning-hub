defmodule HubWeb.AnswerController do
  use HubWeb.ResourceController, for: HubDB.Answer

  import Hub.Spec
  import Norm

  @impl HubWeb.ResourceController
  def resource_s(type \\ nil) do
    s =
      schema(%{
        "id" => positive_integer(),
        "questionId" => positive_integer(),
        "text" => nonempty_string(),
        "createdBy" => nonempty_string(),
        "createdAt" => naive_datetime_string()
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
