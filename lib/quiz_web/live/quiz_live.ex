defmodule QuizWeb.QuizLive do
  use QuizWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, answer: "42")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container">
      <h1 class="mt-0 mb-2 text-5xl font-medium leading-tight text-primary">
        KindQuiz
      </h1>
      <div class="row">
        <div class="col-12">
          <h1>Quiz</h1>
          <p>What is the answer to life, the universe, and everything?</p>
          <p><%= @answer %></p>
          <button phx-click="answer" class="btn btn-primary">Answer</button>
        </div>
      </div>
    </div>
    """
  end
end
