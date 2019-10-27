defmodule HubTest do
  use Hub.DataCase

  describe "questions" do
    alias Hub.Question

    @valid_attrs %{tags: [], text: "some text", created_by: "that_guy"}
    @update_attrs %{tags: [], text: "some updated text"}
    @invalid_attrs %{tags: nil, text: nil}

    def question_fixture(attrs \\ %{}) do
      {:ok, question} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Hub.create_question()

      question
    end

    test "list_questions/0 returns all questions" do
      question = question_fixture()
      assert Hub.list_questions() == [question]
    end

    test "get_question!/1 returns the question with given id" do
      question = question_fixture()
      assert Hub.get_question!(question.id) == question
    end

    test "create_question/1 with valid data creates a question" do
      assert {:ok, %Question{} = question} = Hub.create_question(@valid_attrs)
      assert question.tags == []
      assert question.text == "some text"
    end

    test "create_question/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Hub.create_question(@invalid_attrs)
    end

    test "update_question/2 with valid data updates the question" do
      question = question_fixture()
      assert {:ok, %Question{} = question} = Hub.update_question(question, @update_attrs)
      assert question.tags == []
      assert question.text == "some updated text"
    end

    test "update_question/2 with invalid data returns error changeset" do
      question = question_fixture()
      assert {:error, %Ecto.Changeset{}} = Hub.update_question(question, @invalid_attrs)
      assert question == Hub.get_question!(question.id)
    end

    test "delete_question/1 deletes the question" do
      question = question_fixture()
      assert {:ok, %Question{}} = Hub.delete_question(question)
      assert_raise Ecto.NoResultsError, fn -> Hub.get_question!(question.id) end
    end

    test "change_question/1 returns a question changeset" do
      question = question_fixture()
      assert %Ecto.Changeset{} = Hub.change_question(question)
    end
  end
end
