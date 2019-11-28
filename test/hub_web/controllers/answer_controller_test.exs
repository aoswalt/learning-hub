defmodule HubWeb.AnswerControllerTest do
  use HubWeb.ResourceControllerTest, ctrl: HubWeb.AnswerController

  defp resource(_) do
    question = HubWeb.Helpers.gen_resource(HubDB.Question)
    [resource: HubWeb.Helpers.gen_resource(HubDB.Answer, %{question_id: question.id})]
  end

  defp create_params(_) do
    question = HubWeb.Helpers.gen_resource(HubDB.Question)
    [create_params: gen_params(HubWeb.AnswerController, :create, %{question_id: question.id})]
  end
end
