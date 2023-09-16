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
