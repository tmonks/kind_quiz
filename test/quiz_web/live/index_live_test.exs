defmodule KindQuizWeb.IndexLiveTest do
  use KindQuizWeb.ConnCase, async: true
  import Phoenix.LiveViewTest
  import KindQuiz.Factory

  test "renders a row for each quiz", %{conn: conn} do
    quiz1 = insert(:quiz, title: "What kind of pizza are you?")
    quiz2 = insert(:quiz, title: "What kind of book are you?")
    {:ok, view, _html} = live(conn, "/")

    assert has_element?(view, "#quiz-#{quiz1.id}", "What kind of pizza are you?")
    assert has_element?(view, "#quiz-#{quiz2.id}", "What kind of book are you?")
  end

  test "redirects :category quizzes to QuizLive", %{conn: conn} do
    quiz = insert(:quiz, type: :category, title: "What kind of pizza are you?")
    {:ok, view, _html} = live(conn, "/")

    view
    |> element("#quiz-#{quiz.id}-link")
    |> render_click()

    assert_redirect(view, ~p"/quiz/#{quiz.id}")
  end

  test "redirects trivia quizzes to TriviaLive", %{conn: conn} do
    quiz = insert(:quiz, type: :trivia, title: "What kind of pizza are you?")
    {:ok, view, _html} = live(conn, "/")

    view
    |> element("#quiz-#{quiz.id}-link")
    |> render_click()

    assert_redirect(view, ~p"/trivia/#{quiz.id}")
  end

  test "displays a placeholder image if the quiz does not have an image", %{conn: conn} do
    quiz = insert(:quiz)
    {:ok, view, _html} = live(conn, "/")

    assert has_element?(view, "#quiz-#{quiz.id} img[src='images/placeholder.png']")
  end

  test "displays the quiz image if the quiz has an image", %{conn: conn} do
    quiz = insert(:quiz, image: "pizza.png")
    {:ok, view, _html} = live(conn, "/")

    assert has_element?(view, "#quiz-#{quiz.id} img[src='images/pizza.png']")
  end
end
