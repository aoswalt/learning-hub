defmodule HubJSON.AnswerControllerTest do
  use HubJSON.ResourceControllerTest, ctrl: HubJSON.AnswerController

  defp resource(_) do
    question = HubWeb.Helpers.gen_resource(HubDB.Question)
    [resource: HubWeb.Helpers.gen_resource(HubDB.Answer, %{question_id: question.id})]
  end

  defp create_params(_) do
    question = HubWeb.Helpers.gen_resource(HubDB.Question)
    [create_params: gen_params(HubJSON.AnswerController, :create, %{question_id: question.id})]
  end
end
