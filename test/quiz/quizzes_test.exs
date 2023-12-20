defmodule KQ.QuizzesTest do
  use KQ.DataCase, async: true
  import KQ.Factory

  alias KQ.Quizzes
  alias KQ.Quizzes.Outcome
  alias KQ.Quizzes.Quiz

  describe "create_trivia_quiz/1" do
    test "creates a trivia quiz from a title" do
      assert {:ok, %Quiz{title: "Amazing trivia quiz", type: :trivia}} =
               Quizzes.create_trivia_quiz("Amazing trivia quiz")
    end

    test "returns an error changeset if the title is blank" do
      assert {:error, changeset} = Quizzes.create_trivia_quiz("")
      assert {"can't be blank", _} = changeset.errors[:title]
    end
  end

  describe "create_category_quiz/1" do
    test "creates a category quiz from a title" do
      assert {:ok, %Quiz{title: "Amazing category quiz", type: :category}} =
               Quizzes.create_category_quiz("Amazing category quiz")
    end

    test "returns an error changeset if the title is blank" do
      assert {:error, changeset} = Quizzes.create_category_quiz("")
      assert {"can't be blank", _} = changeset.errors[:title]
    end
  end

  describe "toggle_active/1" do
    test "toggles the is_active flag from false to true" do
      quiz = %{id: quiz_id} = insert(:quiz, is_active: false)
      assert {:ok, %{id: ^quiz_id, is_active: true}} = Quizzes.toggle_active(quiz)
    end

    test "toggles the is_active flag from true to false" do
      quiz = %{id: quiz_id} = insert(:quiz, is_active: true)
      assert {:ok, %{id: ^quiz_id, is_active: false}} = Quizzes.toggle_active(quiz)
    end
  end

  describe "qet_quiz!/1" do
    test "returns a quiz by id" do
      %{id: id} = insert(:quiz, %{title: "What kind of pizza are you?"})

      assert %{id: ^id, title: "What kind of pizza are you?"} = Quizzes.get_quiz!(id)
    end

    test "raises an error if the id is invalid" do
      assert_raise(Ecto.NoResultsError, fn -> Quizzes.get_quiz!(10) end)
    end

    test "preloads questions and answers" do
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
  end

  describe "list_quizzes/0" do
    test "returns a list of all quizzes" do
      %{id: id1} = insert(:quiz)
      %{id: id2} = insert(:quiz)

      assert [%{id: ^id1}, %{id: ^id2}] = Quizzes.list_quizzes()
    end
  end

  describe "list_active_quizzes/0" do
    test "returns a list of all active quizzes" do
      _active_quiz = %{id: active_quiz_id} = insert(:quiz, is_active: true)
      _inactive_quiz = insert(:quiz, is_active: false)

      assert [%{id: ^active_quiz_id}] = Quizzes.list_active_quizzes()
    end
  end

  describe "get_outcome!/1" do
    test "returns the outcome with the given id" do
      quiz = insert(:quiz)
      %{id: id} = insert(:outcome, %{text: "Veggie Pizza", quiz: quiz})
      assert %{id: ^id, text: "Veggie Pizza"} = Quizzes.get_outcome!(id)
    end

    test "raises an error if the outcome id is invalid" do
      assert_raise(Ecto.NoResultsError, fn -> Quizzes.get_outcome!(10) end)
    end
  end

  describe "get_outcome!/2" do
    test "gets an outcome by quiz_id and number" do
      quiz = insert(:quiz)
      %{id: outcome_id} = insert(:outcome, %{text: "Veggie Pizza", quiz: quiz, number: 3})
      assert %{id: ^outcome_id, text: "Veggie Pizza"} = Quizzes.get_outcome!(quiz.id, 3)
    end

    test "raises an error if the outcome number is invalid" do
      quiz = insert(:quiz)
      assert_raise(Ecto.NoResultsError, fn -> Quizzes.get_outcome!(quiz.id, 10) end)
    end
  end

  describe "get_incomplete_quiz/0" do
    test "returns the oldest quiz with less than 10 questions" do
      _quiz1 =
        %{id: quiz1_id} =
        insert(:quiz, type: :trivia, inserted_at: DateTime.utc_now() |> DateTime.add(-60))

      _quiz2 = %{id: _quiz2_id} = insert(:quiz, type: :trivia, inserted_at: DateTime.utc_now())

      assert %{id: ^quiz1_id} = Quizzes.get_incomplete_quiz()
    end

    test "returns nil if there are no incomplete quizzes" do
      quiz = insert(:quiz, type: :trivia, inserted_at: DateTime.utc_now() |> DateTime.add(-60))

      insert_list(10, :question, quiz: quiz)

      assert Quizzes.get_incomplete_quiz() |> is_nil()
    end

    test "will not return a quiz with 10 answers" do
      quiz1 =
        %{id: _quiz1_id} =
        insert(:quiz, type: :trivia, inserted_at: DateTime.utc_now() |> DateTime.add(-60))

      quiz2 = %{id: quiz2_id} = insert(:quiz, type: :trivia, inserted_at: DateTime.utc_now())

      insert_list(10, :question, quiz: quiz1)
      insert_list(9, :question, quiz: quiz2)

      assert %{id: ^quiz2_id} = Quizzes.get_incomplete_quiz()
    end

    test "returns only trivia quizzes" do
      _quiz1 =
        %{id: _quiz1_id} =
        insert(:quiz, type: :category, inserted_at: DateTime.utc_now() |> DateTime.add(-60))

      _quiz2 = %{id: quiz2_id} = insert(:quiz, type: :trivia, inserted_at: DateTime.utc_now())

      assert %{id: ^quiz2_id} = Quizzes.get_incomplete_quiz()
    end
  end

  describe "list_empty_quizzes/0" do
    test "returns a list of all quizzes with no questions" do
      # quiz1 has no questions
      %{id: id1} = insert(:quiz)

      # quiz 2 has a question
      quiz2 = insert(:quiz)
      insert(:question, quiz: quiz2)

      assert [%{id: ^id1}] = Quizzes.list_empty_quizzes()
    end

    test "sorts quizzes by oldest first" do
      %{id: id1} = insert(:quiz, inserted_at: DateTime.utc_now())
      %{id: id2} = insert(:quiz, inserted_at: DateTime.utc_now() |> DateTime.add(-60))
      %{id: id3} = insert(:quiz, inserted_at: DateTime.utc_now() |> DateTime.add(-30))

      assert [%{id: ^id2}, %{id: ^id3}, %{id: ^id1}] = Quizzes.list_empty_quizzes()
    end
  end

  describe "add_outcomes/2" do
    test "adds outcomes to a quiz" do
      quiz = insert(:quiz)

      outcomes = [
        %{text: "Veggie Pizza", image: "veggie", number: 1},
        %{text: "Pepperoni Pizza", image: "pepperoni", number: 2},
        %{text: "Cheese Pizza", image: "cheese", number: 3}
      ]

      assert {:ok, quiz} = Quizzes.add_outcomes(quiz, outcomes)

      assert [
               %Outcome{text: "Veggie Pizza", image: "veggie", number: 1},
               %Outcome{text: "Pepperoni Pizza", image: "pepperoni", number: 2},
               %Outcome{text: "Cheese Pizza", image: "cheese", number: 3}
             ] =
               quiz.outcomes
    end
  end

  describe "set_outcome_image_prompts/2" do
    test "sets the image prompt for each outcome on a quiz" do
      quiz = insert(:quiz)
      outcome1 = insert(:outcome, quiz: quiz, number: 1)
      outcome2 = insert(:outcome, quiz: quiz, number: 2)

      assert {:ok, _quiz} = Quizzes.set_outcome_image_prompts(quiz, "Prompt for outcome image")
      assert %{image_prompt: "Prompt for outcome image"} = Repo.reload(outcome1)
      assert %{image_prompt: "Prompt for outcome image"} = Repo.reload(outcome2)
    end

    test "replaces {{outcome}} placeholders in the image_prompt with the outcome's text" do
      quiz = insert(:quiz)
      insert(:outcome, quiz: quiz, number: 1, text: "Veggie Pizza")

      assert {:ok, %{outcomes: [%{image_prompt: "Image of Veggie Pizza"}]}} =
               Quizzes.set_outcome_image_prompts(quiz, "Image of {{outcome}}")
    end
  end
end
