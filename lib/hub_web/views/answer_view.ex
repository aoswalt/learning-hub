defmodule HubWeb.AnswerView do
  use HubWeb, :view
  alias HubWeb.AnswerView

  def render("index.json", %{answers: answers}) do
    render_many(answers, AnswerView, "answer.json")
  end

  def render("show.json", %{answer: answer}) do
    render_one(answer, AnswerView, "answer.json")
  end

  def render("answer.json", %{answer: answer}) do
    %{
      id: answer.id,
      text: answer.text,
      createdAt: answer.inserted_at,
      createdBy: answer.created_by,
      questionId: answer.question_id
    }
  end
end
