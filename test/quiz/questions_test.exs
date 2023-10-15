defmodule KindQuiz.QuestionsTest do
  use KindQuiz.DataCase, async: true
  import KindQuiz.Factory

  alias KindQuiz.Questions

  test "get_quiz!/1 returns a quiz by id" do
    %{id: id} = insert(:quiz, %{title: "What kind of pizza are you?"})

    assert %{id: ^id, title: "What kind of pizza are you?"} = Questions.get_quiz!(id)
  end

  test "get_quiz!/1 raises an error if the id is invalid" do
    assert_raise(Ecto.NoResultsError, fn -> Questions.get_quiz!(10) end)
  end

  # test "get_quiz!/1 preloads questions" do
  #   %{id: id} = insert(:quiz, %{title: "What kind of pizza are you?"})
  #   insert(:question, %{quiz_id: id, text: "What is your favorite topping?"})

  #   assert %{id: ^id, title: "What kind of pizza are you?", questions: [question]} =
  #            Questions.get_quiz!(id)

  #   assert %{text: "What is your favorite topping?"} = question
  # end

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
    assert_raise(ArgumentError, fn -> Questions.get_outcome!(-1) end)
  end
end
