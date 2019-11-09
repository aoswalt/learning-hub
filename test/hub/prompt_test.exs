defmodule Hub.PromptTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  alias Hub.{Answer, Prompt}

  property "adding a question" do
    check all(
            prompt <- Norm.gen(Prompt.s()),
            answer <- Norm.gen(Answer.s())
          ) do
      updated_prompt = Prompt.add_answer(prompt, answer)
      assert Enum.member?(updated_prompt.answers, answer)
    end
  end

  property "choosing a solution" do
    check all(
            prompt <- Norm.gen(Prompt.s()),
            length(prompt.answers) > 0
          ) do
      solution = List.first(prompt.answers)
      updated_prompt = Prompt.choose_solution(prompt, solution.id)

      assert updated_prompt.solution == solution
      assert not Enum.member?(updated_prompt.answers, solution)
    end
  end

  test "attempting to choose a solution with no answers raises" do
    prompt =
      Prompt.s()
      |> Norm.gen()
      |> Enum.take(1)
      |> List.first()
      |> Map.put(:answers, [])

    assert_raise RuntimeError, fn -> Prompt.choose_solution(prompt, 1) end
  end
end
