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
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
      <%= for quiz <- @quizzes do %>
        <!-- Card -->
        <div
          id={"quiz-#{quiz.id}"}
          class="bg-white p-4 rounded shadow flex flex-col justify-between gap-4"
        >
          <h2 class="text-lg font-semibold mb-2"><%= quiz.title %></h2>
          <div>
            <a
              type="button"
              id={"quiz-#{quiz.id}-button"}
              class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 text-center"
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
