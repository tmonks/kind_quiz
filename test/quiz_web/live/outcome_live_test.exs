defmodule KindQuizWeb.OutcomeLiveTest do
  use KindQuizWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import KindQuiz.Factory

  test "renders the outcome from the id param", %{conn: conn} do
    %{id: id} = insert(:outcome, text: "Veggie Pizza")
    assert {:ok, view, _html} = live(conn, ~p"/outcome/#{id}")

    assert has_element?(view, "#outcome", "Veggie Pizza")
  end

  test "has a button to restart the quiz", %{conn: conn} do
    %{id: id} = insert(:outcome)
    assert {:ok, view, _html} = live(conn, ~p"/outcome/#{id}")

    view
    |> element("#restart-quiz-button")
    |> render_click()
    |> follow_redirect(conn, ~p"/")
  end

  test "displays a picture of the outcome if one is set", %{conn: conn} do
    %{id: id} = insert(:outcome, image: "outcome-5.jpg")
    assert {:ok, view, _html} = live(conn, ~p"/outcome/#{id}")

    assert has_element?(view, "img[src='/images/outcome-5.jpg']")
  end

  test "does not display picture if the outcome does not have one", %{conn: conn} do
    %{id: id} = insert(:outcome, image: nil)
    assert {:ok, view, _html} = live(conn, ~p"/outcome/#{id}")

    refute has_element?(view, "img")
  end
end
