defmodule KQWeb.OutcomeLiveTest do
  use KQWeb.ConnCase, async: false

  import Phoenix.LiveViewTest
  import KQ.Factory

  test "renders the outcome from the id param", %{conn: conn} do
    quiz = insert(:quiz, id: 5)
    insert(:outcome, number: 3, quiz: quiz, text: "Veggie Pizza")
    assert {:ok, view, _html} = live(conn, ~p"/quiz/5/outcome/3")

    assert has_element?(view, "#quiz-title")
    assert has_element?(view, "#outcome", "Veggie Pizza")
  end

  test "has a button to restart the quiz", %{conn: conn} do
    outcome = insert(:outcome)
    assert {:ok, view, _html} = live(conn, ~p"/quiz/#{outcome.quiz.id}/outcome/#{outcome.number}")

    view
    |> element("#restart-quiz-button")
    |> render_click()
    |> follow_redirect(conn, ~p"/")
  end

  test "displays a picture of the outcome if one is set", %{conn: conn} do
    outcome = insert(:outcome, image: "outcome-5.jpg")
    assert {:ok, view, _html} = live(conn, ~p"/quiz/#{outcome.quiz.id}/outcome/#{outcome.number}")

    assert has_element?(view, "img[src='/images/outcome-5.jpg']")
  end

  test "does not display picture if the outcome does not have one", %{conn: conn} do
    outcome = insert(:outcome, image: nil)
    assert {:ok, view, _html} = live(conn, ~p"/quiz/#{outcome.quiz.id}/outcome/#{outcome.number}")

    refute has_element?(view, "img")
  end
end
