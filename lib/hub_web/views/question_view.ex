defmodule HubWeb.QuestionView do
  use HubWeb, :view
  alias HubWeb.QuestionView

  def render("index.json", %{questions: questions}) do
    render_many(questions, QuestionView, "question.json")
  end

  def render("show.json", %{question: question}) do
    render_one(question, QuestionView, "question.json")
  end

  def render("question.json", %{question: question}) do
    %{id: question.id, text: question.text, tags: question.tags}
  end
end
