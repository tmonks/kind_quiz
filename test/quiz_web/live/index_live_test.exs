defmodule KindQuizWeb.IndexLiveTest do
  use KindQuizWeb.ConnCase, async: true
  import Phoenix.LiveViewTest
  import KindQuiz.Factory

  test "renders a row for each quiz", %{conn: conn} do
    quiz1 = insert(:quiz, title: "What kind of pizza are you?")
    quiz2 = insert(:quiz, title: "What kind of book are you?")
    {:ok, view, _html} = live(conn, "/")

    open_browser(view)

    assert has_element?(view, "#quiz-#{quiz1.id}", "What kind of pizza are you?")
    assert has_element?(view, "#quiz-#{quiz2.id}", "What kind of book are you?")
  end

  test "has a button to start each quiz", %{conn: conn} do
    quiz = insert(:quiz, title: "What kind of pizza are you?")
    {:ok, view, _html} = live(conn, "/")

    view
    |> element("#quiz-#{quiz.id}-button")
    |> render_click()
    |> follow_redirect(conn, ~p"/quiz/#{quiz.id}")
  end
end
