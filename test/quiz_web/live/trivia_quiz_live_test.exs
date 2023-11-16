defmodule KindQuizWeb.TriviaQuizLiveTest do
  use KindQuizWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import KindQuiz.Factory

  setup :setup_quiz

  test "renders the quiz page with the quiz title at the top", %{conn: conn} do
    {:ok, view, html} = live(conn, ~p"/trivia/7")

    assert html =~ "Trivia Quiz"

    assert has_element?(
             view,
             "#question-text",
             "What is your favorite color?"
           )
  end

  test "has a Submit button that's initially disabled", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/trivia/7")

    assert has_element?(view, "#submit-button[disabled]")
  end

  test "selecting an answer enables the Submit button", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/trivia/7")

    view
    |> form("#quiz-form", %{"response" => "1"})
    |> render_change()

    refute has_element?(view, "#submit-button[disabled]")
  end

  test "submitting the form shows the question result and the Next button", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/trivia/7")

    view
    |> form("#quiz-form", %{"response" => "1"})
    |> render_submit()

    assert has_element?(view, "#result")
    assert has_element?(view, "#next-button", "Next")
  end

  test "Shows correct if the answer was correct", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/trivia/7")

    view
    |> form("#quiz-form", %{"response" => "1"})
    |> render_submit()

    assert has_element?(view, "#result", "Correct!")
  end

  test "Shows Incorrect if the answer was incorrect", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/trivia/7")

    view
    |> form("#quiz-form", %{"response" => "2"})
    |> render_submit()

    assert has_element?(view, "#result", "Incorrect")
  end

  test "submitting the form disables the radio buttons", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/trivia/7")

    view
    |> form("#quiz-form", %{"response" => "1"})
    |> render_submit()

    assert has_element?(view, "#answer-1[disabled]")
    assert has_element?(view, "#answer-2[disabled]")
    assert has_element?(view, "#answer-3[disabled]")
    assert has_element?(view, "#answer-4[disabled]")
  end

  test "clicking Next goes to the next question", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/trivia/7")

    view
    |> form("#quiz-form", %{"response" => "1"})
    |> render_submit()

    view
    |> element("#next-button")
    |> render_click()

    assert has_element?(
             view,
             "#question-text",
             "What is your preferred method of transportation?"
           )

    assert has_element?(view, "#question-counter", "(2 of 2)")
  end

  test "completing the quiz shows your score", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/trivia/7")

    view
    |> form("#quiz-form", %{"response" => "1"})
    |> render_submit()

    view |> element("#next-button") |> render_click()

    view
    |> form("#quiz-form", %{"response" => "1"})
    |> render_submit()

    view |> element("#next-button") |> render_click()

    assert has_element?(view, "#score", "50%")
    assert has_element?(view, "#home-button")
  end

  defp setup_quiz(_) do
    quiz = insert(:quiz, id: 7, title: "Trivia Quiz")

    insert(:question,
      id: 1,
      text: "What is your favorite color?",
      correct: 1,
      explanation: "Red is the best color.",
      quiz: quiz,
      answers: [
        %{id: 1, number: 1, text: "Red"},
        %{id: 2, number: 2, text: "Blue"},
        %{id: 3, number: 3, text: "Green"},
        %{id: 4, number: 4, text: "Yellow"}
      ]
    )

    insert(:question,
      id: 2,
      text: "What is your preferred method of transportation?",
      correct: 2,
      explanation: "Walking is the best way to get around.",
      quiz: quiz,
      answers: [
        %{id: 5, number: 1, text: "Car"},
        %{id: 6, number: 2, text: "Walking"},
        %{id: 7, number: 3, text: "Bike"},
        %{id: 8, number: 4, text: "Bus"}
      ]
    )

    %{quiz: quiz}
  end
end
