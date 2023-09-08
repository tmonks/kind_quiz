defmodule Quiz.QuestionsTest do
  use ExUnit.Case, async: true

  alias Quiz.Questions

  describe "get_questions/1" do
    test "returns an array of questions and answers" do
      assert [question1 | _] = questions = Questions.get_questions()
      assert length(questions) == 5
      assert %{text: _, answers: answers} = question1
      assert answers |> length() > 1
    end
  end

  describe "get_title/1" do
    test "returns the title of the quiz" do
      assert Questions.get_title() == "What kind of superhero are you?"
    end
  end
end
