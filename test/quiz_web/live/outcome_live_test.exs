defmodule QuizWeb.OutcomeLiveTest do
  use QuizWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "renders the outcome from the id param", %{conn: conn} do
    assert {:ok, view, _html} = live(conn, ~p"/outcome/1")

    assert has_element?(view, "#outcome", "Black Panther")
  end

  test "has a button to restart the quiz", %{conn: conn} do
    assert {:ok, view, _html} = live(conn, ~p"/outcome/1")

    view
    |> element("#restart-quiz-button")
    |> render_click()
    |> follow_redirect(conn, ~p"/")
  end

  test "displays a picture of the outcome", %{conn: conn} do
    assert {:ok, view, _html} = live(conn, ~p"/outcome/1")

    assert has_element?(view, "img[src='/images/outcome-1.jpg']")
  end
end
