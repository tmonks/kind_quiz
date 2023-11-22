defmodule KindQuiz.QuizzesTest do
  use KindQuiz.DataCase, async: true
  import KindQuiz.Factory

  alias KindQuiz.Quizzes

  test "get_quiz!/1 returns a quiz by id" do
    %{id: id} = insert(:quiz, %{title: "What kind of pizza are you?"})

    assert %{id: ^id, title: "What kind of pizza are you?"} = Quizzes.get_quiz!(id)
  end

  test "get_quiz!/1 raises an error if the id is invalid" do
    assert_raise(Ecto.NoResultsError, fn -> Quizzes.get_quiz!(10) end)
  end

  test "get_quiz!/1 preloads questions and answers" do
    %{id: id} = insert(:quiz, %{title: "What kind of pizza are you?"})

    question =
      %{id: question_id} =
      insert(:question, %{quiz_id: id, text: "What is your favorite topping?"})

    %{id: answer_id} = insert(:answer, %{question_id: question.id, text: "Pepperoni"})

    assert %{id: ^id, title: "What kind of pizza are you?", questions: [question]} =
             Quizzes.get_quiz!(id)

    assert %{id: ^question_id, text: "What is your favorite topping?", answers: [answer]} =
             question

    assert %{id: ^answer_id, text: "Pepperoni"} = answer
  end

  describe "list_quizzes/0" do
    test "returns a list of all quizzes" do
      %{id: id1} = insert(:quiz)
      %{id: id2} = insert(:quiz)

      assert [%{id: ^id1}, %{id: ^id2}] = Quizzes.list_quizzes()
    end
  end

  test "get_questions/0 returns an array of questions and answers" do
    assert [question1 | _] = questions = Quizzes.get_questions()
    assert length(questions) == 5
    assert %{text: _, answers: answers} = question1
    assert answers |> length() > 1
  end

  test "get_title/0 returns the title of the quiz" do
    assert Quizzes.get_title() == "What kind of superhero are you?"
  end

  test "list_outcomes/0 returns the list of possible outcomes" do
    assert ["Captain America", "Black Panther", "Iron Man", "Hawkeye", "Thor"] =
             Quizzes.list_outcomes()
  end

  test "get_outcome!/1 returns the outcome with the given id" do
    quiz = insert(:quiz)
    %{id: id} = insert(:outcome, %{text: "Veggie Pizza", quiz: quiz})
    assert %{id: ^id, text: "Veggie Pizza"} = Quizzes.get_outcome!(id)
  end

  test "get_outcome!/1 raises an error if the outcome id is invalid" do
    assert_raise(Ecto.NoResultsError, fn -> Quizzes.get_outcome!(10) end)
  end

  test "get_outcome!/2 gets an outcome by quiz_id and number" do
    quiz = insert(:quiz)
    %{id: outcome_id} = insert(:outcome, %{text: "Veggie Pizza", quiz: quiz, number: 3})
    assert %{id: ^outcome_id, text: "Veggie Pizza"} = Quizzes.get_outcome!(quiz.id, 3)
  end

  test "get_outcome!/2 raises an error if the outcome number is invalid" do
    quiz = insert(:quiz)
    assert_raise(Ecto.NoResultsError, fn -> Quizzes.get_outcome!(quiz.id, 10) end)
  end

  test "get_incomplete_quiz/0 returns the oldest quiz with less than 10 questions" do
    _quiz1 = %{id: quiz1_id} = insert(:quiz, inserted_at: DateTime.utc_now() |> DateTime.add(-60))
    _quiz2 = %{id: _quiz2_id} = insert(:quiz, inserted_at: DateTime.utc_now())

    assert %{id: ^quiz1_id} = Quizzes.get_incomplete_quiz()
  end

  test "get_incomplete_quiz/0 returns nil if there are no incomplete quizzes" do
    quiz = insert(:quiz, inserted_at: DateTime.utc_now() |> DateTime.add(-60))

    insert_list(10, :question, quiz: quiz)

    assert Quizzes.get_incomplete_quiz() |> is_nil()
  end

  test "get_incomplete_quiz/0 will not return a quiz with 10 answers" do
    quiz1 = %{id: _quiz1_id} = insert(:quiz, inserted_at: DateTime.utc_now() |> DateTime.add(-60))
    quiz2 = %{id: quiz2_id} = insert(:quiz, inserted_at: DateTime.utc_now())

    insert_list(10, :question, quiz: quiz1)
    insert_list(9, :question, quiz: quiz2)

    assert %{id: ^quiz2_id} = Quizzes.get_incomplete_quiz()
  end
end
