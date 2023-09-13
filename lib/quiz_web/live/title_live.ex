defmodule QuizWeb.TitleLive do
  use QuizWeb, :live_view

  alias Quiz.Questions

  @impl true
  def mount(_params, _session, socket) do
    title = Questions.get_title()
    {:ok, assign(socket, title: title)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container mx-auto text-center pt-28">
      <div class="mx-auto">
        <h1 id="quiz-title" class="text-4xl font-bold"><%= @title %></h1>
        <a
          type="button"
          id="start-quiz-button"
          class="mt-8 bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
          href={~p"/quiz"}
        >
          Take the quiz
        </a>
      </div>
    </div>
    """
  end
end
