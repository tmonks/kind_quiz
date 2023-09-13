defmodule QuizWeb.TitleLiveTest do
  use QuizWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  test "renders a title page with the quiz title", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    assert has_element?(view, "#quiz-title", "What kind of superhero are you?")
  end

  test "has a button to start the quiz", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    view
    |> element("#start-quiz-button")
    |> render_click()
    |> follow_redirect(conn, ~p"/quiz")
  end
end
