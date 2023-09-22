defmodule QuizWeb.QuizLiveTest do
  use QuizWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "renders the quiz page with the question at the top", %{conn: conn} do
    {:ok, _view, html} = live(conn, ~p"/quiz")

    assert html =~ "What kind of superhero are you?"
  end

  test "renders the first question on load", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/quiz")

    assert has_element?(view, "#question-text", "What is your favorite subject in school?")
    assert has_element?(view, "label", "History")
    assert has_element?(view, "label", "Science")
    assert has_element?(view, "label", "Technology")
    assert has_element?(view, "label", "Physical Education")
    assert has_element?(view, "label", "Mythology")
  end

  test "Next button is initially disabled", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/quiz")

    assert has_element?(view, "#next-button[disabled]")
  end

  test "Selecting an answer enables the Next button", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/quiz")

    view
    |> form("#quiz-form", %{"response" => "1"})
    |> render_change()

    refute has_element?(view, "#next-button[disabled]")
  end

  test "submitting the form shows the next question", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/quiz")

    view
    |> form("#quiz-form", %{"response" => "1"})
    |> render_submit()

    assert has_element?(view, "#question-text", "How do you like to spend your free time?")
  end

  test "redirects to the outcome for the most frequent answer", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/quiz")

    # majority of answers are 1
    view |> form("#quiz-form", %{"response" => 1}) |> render_submit()
    view |> form("#quiz-form", %{"response" => 1}) |> render_submit()
    view |> form("#quiz-form", %{"response" => 1}) |> render_submit()
    view |> form("#quiz-form", %{"response" => 2}) |> render_submit()

    view
    |> form("#quiz-form", %{"response" => 2})
    |> render_submit()
    # redirected to outcome 1
    |> follow_redirect(conn, ~p"/outcome/1")
  end
end
