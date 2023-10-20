defmodule KindQuizWeb.IndexLive do
  use KindQuizWeb, :live_view

  alias KindQuiz.Questions

  @impl true
  def mount(_params, _session, socket) do
    quizzes = Questions.list_quizzes()
    {:ok, assign(socket, quizzes: quizzes)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container mx-auto text-center pt-28">
      <%= for quiz <- @quizzes do %>
        <div id={"quiz-#{quiz.id}"} class="mb-8 mx-auto flex gap-2">
          <div class="text-3xl min-w-100 font-bold"><%= quiz.title %></div>
          <div>
            <a
              type="button"
              id={"quiz-#{quiz.id}-button"}
              class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
              href={~p"/quiz/#{quiz.id}"}
            >
              Take the quiz
            </a>
          </div>
        </div>
      <% end %>
    </div>
    """
  end
end
