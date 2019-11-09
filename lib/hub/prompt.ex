defmodule Hub.Prompt do
  import Norm

  alias Hub.{Answer, Question}

  defstruct question: nil,
            solution: nil,
            answers: []

  def s(),
    do:
      schema(%__MODULE__{
        question: with_gen(&match?(%Question{}, &1), gen(Question.s())),
        solution: with_gen(&match?(%Answer{}, &1), gen(Answer.s())),
        answers:
          with_gen(
            spec(is_list() and fn tags -> Enum.all?(tags, &match?(%Answer{}, &1)) end),
            StreamData.list_of(gen(Answer.s()))
          )
      })

  def new(%Question{} = question) do
    struct!(__MODULE__, question: question)
  end

  def new(text, tags \\ []) do
    text
    |> Question.new(tags)
    |> new()
  end

  def add_answer(%__MODULE__{} = prompt, %Answer{} = answer) do
    %{prompt | answers: [answer | prompt.answers]}
  end

  def choose_solution(%{answers: []}, _answer_id) do
    raise "No answers when choosing solution"
  end

  def choose_solution(%__MODULE__{} = prompt, answer_id) do
    index = Enum.find_index(prompt.answers, &(&1.id == answer_id))
    {solution, answers} = List.pop_at(prompt.answers, index)

    %{prompt | solution: solution, answers: answers}
  end
end
