defmodule KindQuizWeb.QuizLiveTest do
  use KindQuizWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import KindQuiz.Factory

  alias KindQuiz.Repo

  setup :setup_quiz

  test "renders the quiz page with the quiz title at the top", %{conn: conn, quiz: quiz} do
    {:ok, _view, html} = live(conn, ~p"/quiz/#{quiz.id}")

    assert html =~ "What kind of pizza are you?"
  end

  test "renders the first question on load", %{conn: conn, quiz: quiz} do
    {:ok, view, _html} = live(conn, ~p"/quiz/#{quiz.id}")

    [answer1, answer2, answer3] = Enum.at(quiz.questions, 0).answers

    assert has_element?(view, "#question-text", "What is your favorite TV show?")
    assert has_element?(view, "input#answer-#{answer1.id}[value=#{answer1.outcome_id}]")
    assert has_element?(view, "input#answer-#{answer2.id}[value=#{answer2.outcome_id}]")
    assert has_element?(view, "input#answer-#{answer3.id}[value=#{answer3.outcome_id}]")
  end

  test "Next button is initially disabled", %{conn: conn, quiz: quiz} do
    {:ok, view, _html} = live(conn, ~p"/quiz/#{quiz.id}")

    assert has_element?(view, "#next-button[disabled]")
  end

  test "Selecting an answer enables the Next button", %{conn: conn, quiz: quiz} do
    {:ok, view, _html} = live(conn, ~p"/quiz/#{quiz.id}")

    view
    |> form("#quiz-form", %{"response" => "1"})
    |> render_change()

    refute has_element?(view, "#next-button[disabled]")
  end

  test "submitting the form shows the next question", %{conn: conn, quiz: quiz} do
    {:ok, view, _html} = live(conn, ~p"/quiz/#{quiz.id}")

    view
    |> form("#quiz-form", %{"response" => "1"})
    |> render_submit()

    assert has_element?(view, "#question-text", "How do you like to spend your free time?")
  end

  test "shows the question progress (x of y)", %{conn: conn, quiz: quiz} do
    total_questions = length(quiz.questions)

    {:ok, view, _html} = live(conn, ~p"/quiz/#{quiz.id}")

    assert has_element?(view, "#question-counter", "(1 of #{total_questions})")

    view
    |> form("#quiz-form", %{"response" => "1"})
    |> render_submit()

    assert has_element?(view, "#question-counter", "(2 of #{total_questions})")
  end

  test "redirects to the outcome for the most frequent answer", %{conn: conn, quiz: quiz} do
    {:ok, view, _html} = live(conn, ~p"/quiz/#{quiz.id}")

    # majority of answers are 1
    view |> form("#quiz-form", %{"response" => 1}) |> render_submit()
    view |> form("#quiz-form", %{"response" => 1}) |> render_submit()

    view
    |> form("#quiz-form", %{"response" => 2})
    |> render_submit()
    # redirected to outcome 1
    |> follow_redirect(conn, ~p"/outcome/1")
  end

  defp setup_quiz(_) do
    quiz = insert(:quiz, title: "What kind of pizza are you?")
    outcome1 = insert(:outcome, text: "You are a pepperoni pizza!", quiz_id: quiz.id)
    outcome2 = insert(:outcome, text: "You are a cheese pizza!", quiz_id: quiz.id)
    outcome3 = insert(:outcome, text: "You are a pineapple pizza!", quiz_id: quiz.id)

    insert(:question,
      # id: 4,
      text: "What is your favorite TV show?",
      quiz_id: quiz.id,
      answers: [
        build(:answer, text: "The Simpsons", outcome: outcome1),
        build(:answer, text: "The Office", outcome: outcome2),
        build(:answer, text: "The Mandalorian", outcome: outcome3)
      ]
    )

    insert(:question,
      # id: 5,
      text: "How do you like to spend your free time?",
      quiz_id: quiz.id,
      answers: [
        build(:answer, text: "Watching TV", outcome: outcome1),
        build(:answer, text: "Reading", outcome: outcome2),
        build(:answer, text: "Playing video games", outcome: outcome3)
      ]
    )

    insert(:question,
      # id: 6,
      text: "What is your favorite sport?",
      quiz_id: quiz.id,
      answers: [
        build(:answer, text: "Football", outcome: outcome1),
        build(:answer, text: "Baseball", outcome: outcome2),
        build(:answer, text: "Basketball", outcome: outcome3)
      ]
    )

    quiz = Repo.preload(quiz, questions: :answers)

    %{quiz: quiz}
  end
end
