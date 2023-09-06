defmodule QuizWeb.QuizLiveTest do
  use QuizWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "renders the quiz page", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/")

    assert html =~ "KindQuiz"
  end
end
