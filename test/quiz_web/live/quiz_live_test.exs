defmodule QuizWeb.QuizLiveTest do
  use QuizWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "renders the quiz page", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/")

    assert html =~ "KindQuiz"
  end

  test "renders questions from the quiz csv", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    assert has_element?(view, "#question-0", "What is your favorite subject in school?")
    assert has_element?(view, "#question-0 label", "History")
    assert has_element?(view, "#question-0 label", "Science")
    assert has_element?(view, "#question-0 label", "Technology")
    assert has_element?(view, "#question-0 label", "Physical Education")
    assert has_element?(view, "#question-0 label", "Mythology")
  end

  test "redirects to the outcome for the most frequent answer", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/")

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