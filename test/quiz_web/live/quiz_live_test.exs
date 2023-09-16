defmodule QuizWeb.QuizLiveTest do
  use QuizWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "renders the quiz page with the question at the top", %{conn: conn} do
    {:ok, _view, html} = live(conn, ~p"/quiz")

    assert html =~ "What kind of superhero are you?"
  end

  test "renders the first question on load", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/quiz")

    assert has_element?(view, "#question-0", "What is your favorite subject in school?")
    assert has_element?(view, "#question-0 label", "History")
    assert has_element?(view, "#question-0 label", "Science")
    assert has_element?(view, "#question-0 label", "Technology")
    assert has_element?(view, "#question-0 label", "Physical Education")
    assert has_element?(view, "#question-0 label", "Mythology")
  end

  test "Next button is initially disabled", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/quiz")

    assert has_element?(view, "#next-button[disabled]")
  end

  test "Selecting an answer enables the Next button", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/quiz")

    view
    |> form("#quiz-form", %{"question-0" => "1"})
    |> render_change()

    refute has_element?(view, "#next-button[disabled]")
  end

  test "Clicking Next shows the next question", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/quiz")

    view
    |> form("#quiz-form", %{"question-0" => "1"})
    |> render_change()

    view
    |> element("#next-button")
    |> render_click()

    assert has_element?(view, "#question-1", "How do you like to spend your free time?")
  end

  @tag :skip
  test "redirects to the outcome for the most frequent answer", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/quiz")

    answers = %{
      "question-0" => "1",
      "question-1" => "1",
      "question-2" => "1",
      "question-3" => "2",
      "question-4" => "2"
    }

    view
    |> form("#quiz-form", answers)
    |> render_submit()
    |> follow_redirect(conn, ~p"/outcome/1")
  end
end
