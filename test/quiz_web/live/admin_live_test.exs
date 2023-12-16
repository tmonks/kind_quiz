defmodule KQWeb.AdminLiveTest do
  use KQWeb.ConnCase, async: true
  import Phoenix.LiveViewTest
  import KQ.Factory

  alias KQ.Quizzes

  describe "unauthenticated" do
    test "returns 401 when not logged in", %{conn: conn} do
      conn = get(conn, "/admin")
      assert response(conn, 401)
    end
  end

  describe "authenticated" do
    setup :login_user

    test "renders a card for each quiz", %{conn: conn} do
      quiz1 = insert(:quiz, title: "What kind of pizza are you?")
      quiz2 = insert(:quiz, title: "What kind of book are you?")
      {:ok, view, _html} = live(conn, "/admin")

      assert has_element?(view, "#quiz-#{quiz1.id}", "What kind of pizza are you?")
      assert has_element?(view, "#quiz-#{quiz2.id}", "What kind of book are you?")
    end

    test "redirects :category quizzes to QuizLive", %{conn: conn} do
      quiz = insert(:quiz, type: :category, title: "What kind of pizza are you?")
      {:ok, view, _html} = live(conn, "/admin")

      view
      |> element("#quiz-#{quiz.id}-link")
      |> render_click()

      assert_redirect(view, ~p"/quiz/#{quiz.id}")
    end

    test "redirects trivia quizzes to TriviaLive", %{conn: conn} do
      quiz = insert(:quiz, type: :trivia, title: "What kind of pizza are you?")
      {:ok, view, _html} = live(conn, "/admin")

      view
      |> element("#quiz-#{quiz.id}-link")
      |> render_click()

      assert_redirect(view, ~p"/trivia/#{quiz.id}")
    end

    test "displays a placeholder image if the quiz does not have an image", %{conn: conn} do
      quiz = insert(:quiz)
      {:ok, view, _html} = live(conn, "/admin")

      assert has_element?(view, "#quiz-#{quiz.id} img[src='images/placeholder.png']")
    end

    test "displays the quiz image if the quiz has an image", %{conn: conn} do
      quiz = insert(:quiz, image: "pizza.png")
      {:ok, view, _html} = live(conn, "/admin")

      assert has_element?(view, "#quiz-#{quiz.id} img[src='images/quiz/pizza.png']")
    end

    test "has a checkbox on each card to toggle the quiz's active status", %{conn: conn} do
      quiz = insert(:quiz, is_active: true)
      {:ok, view, _html} = live(conn, "/admin")

      assert has_element?(view, "#quiz-#{quiz.id} input[type='checkbox']")
    end

    test "the checkbox is checked if the quiz is active", %{conn: conn} do
      active_quiz = insert(:quiz, is_active: true)
      inactive_quiz = insert(:quiz, is_active: false)
      {:ok, view, _html} = live(conn, "/admin")

      assert has_element?(view, "#quiz-#{active_quiz.id} input[type='checkbox'][checked]")
      refute has_element?(view, "#quiz-#{inactive_quiz.id} input[type='checkbox'][checked]")
    end

    test "toggling the checkbox updates the quiz's active status", %{conn: conn} do
      quiz = insert(:quiz, is_active: false)
      {:ok, view, _html} = live(conn, "/admin")

      # checkbox is unchecked
      refute has_element?(view, "#quiz-#{quiz.id} input[type='checkbox'][checked]")

      view
      |> element("#quiz-#{quiz.id} input[type='checkbox']")
      |> render_click()

      # checkbox is checked
      assert has_element?(view, "#quiz-#{quiz.id} input[type='checkbox'][checked]")
      # quiz is updated
      assert Quizzes.get_quiz!(quiz.id).is_active == true
    end
  end
end
