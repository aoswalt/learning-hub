defmodule HubWeb.Helpers do
  defmodule Question do
    def create() do
      {:ok, question} =
        :create
        |> gen_params()
        |> Map.new(fn {k, v} -> {Phoenix.Naming.underscore(k), v} end)
        |> Hub.create_question()

      question
    end

    def gen_params(type) do
      type
      |> HubWeb.QuestionController.resource_s()
      |> Norm.gen()
      |> Enum.take(1)
      |> List.first()
    end

    def invalid_params(type) do
      params = gen_params(type)
      bad_key = params |> Map.keys() |> Enum.random()

      Map.put(params, bad_key, nil)
    end
  end

  defmodule Answer do
    def create(question_id) do
      {:ok, answer} =
        :create
        |> gen_params(question_id)
        |> Map.new(fn {k, v} -> {Phoenix.Naming.underscore(k), v} end)
        |> Hub.create_answer()

      answer
    end

    def gen_params(type, question_id \\ nil) do
      params = type
      |> HubWeb.AnswerController.resource_s()
      |> Norm.gen()
      |> Enum.take(1)
      |> List.first()

      if question_id do
        Map.put(params, "question_id", question_id)
      else
        params
      end
    end

    def invalid_params(type) do
      params = gen_params(type, 1)
      bad_key = params |> Map.keys() |> Enum.random()

      Map.put(params, bad_key, nil)
    end
  end
end
