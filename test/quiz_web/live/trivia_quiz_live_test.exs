defmodule KindQuizWeb.TriviaQuizLiveTest do
  use KindQuizWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  # import KindQuiz.Factory

  # alias KindQuiz.Repo

  test "renders the quiz page with the quiz title at the top", %{conn: conn} do
    {:ok, _view, html} = live(conn, ~p"/trivia/1")

    assert html =~ "Trivia Quiz"
  end

  test "has a Submit button that's initially disabled", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/trivia/1")

    assert has_element?(view, "#submit-button[disabled]")
  end

  test "selecting an answer enables the Submit button", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/trivia/1")

    view
    |> form("#quiz-form", %{"response" => "1"})
    |> render_change()

    refute has_element?(view, "#submit-button[disabled]")
  end

  test "submitting the form shows the question result and the Next button", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/trivia/1")

    view
    |> form("#quiz-form", %{"response" => "1"})
    |> render_submit()

    assert has_element?(view, "#result")
    assert has_element?(view, "#next-button", "Next")
  end

  test "Shows correct if the answer was correct", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/trivia/1")

    view
    |> form("#quiz-form", %{"response" => "1"})
    |> render_submit()

    assert has_element?(view, "#result", "Correct!")
  end

  test "Shows Incorrect if the answer was incorrect", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/trivia/1")

    view
    |> form("#quiz-form", %{"response" => "2"})
    |> render_submit()

    assert has_element?(view, "#result", "Incorrect")
  end

  test "submitting the form disables the radio buttons", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/trivia/1")

    view
    |> form("#quiz-form", %{"response" => "1"})
    |> render_submit()

    assert has_element?(view, "#answer-1[disabled]")
    assert has_element?(view, "#answer-2[disabled]")
    assert has_element?(view, "#answer-3[disabled]")
    assert has_element?(view, "#answer-4[disabled]")
  end

  test "clicking Next goes to the next question", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/trivia/1")

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

    assert has_element?(view, "#question-counter", "(2 of 5)")
  end

  test "completing the quiz shows your score", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/trivia/1")

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
end
