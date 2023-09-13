defmodule Quiz.QuestionsTest do
  use ExUnit.Case, async: true

  alias Quiz.Questions

  test "get_questions/0 returns an array of questions and answers" do
    assert [question1 | _] = questions = Questions.get_questions()
    assert length(questions) == 5
    assert %{text: _, answers: answers} = question1
    assert answers |> length() > 1
  end

  test "get_title/0 returns the title of the quiz" do
    assert Questions.get_title() == "What kind of superhero are you?"
  end

  test "list_outcomes/0 returns the list of possible outcomes" do
    assert ["Captain America", "Black Panther", "Iron Man", "Hawkeye", "Thor"] =
             Questions.list_outcomes()
  end

  test "get_outcome!/1 returns the outcome with the given id" do
    assert Questions.get_outcome!(1) == "Black Panther"
  end

  test "get_outcome!/1 raises an error if the outcome id is invalid" do
    assert_raise(ArgumentError, fn -> Questions.get_outcome!(10) end)
  end
end