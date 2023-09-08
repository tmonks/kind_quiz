defmodule QuizWeb.QuizLiveTest do
  use QuizWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "renders the quiz page", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/")

    assert html =~ "KindQuiz"
  end

  test "renders questions from the quiz csv", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    assert has_element?(view, "#question-1")
    assert has_element?(view, "#question-1", "What is your favorite subject in school?")
  end
end
