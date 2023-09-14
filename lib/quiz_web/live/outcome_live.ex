defmodule QuizWeb.OutcomeLive do
  use QuizWeb, :live_view

  alias Quiz.Questions

  def handle_params(%{"id" => id}, _uri, socket) do
    id = String.to_integer(id)
    outcome = Questions.get_outcome!(id)

    {:noreply, assign(socket, outcome: outcome)}
  end

  def render(assigns) do
    ~H"""
    <div class="mt-28 mt-2 text-center">
      <h1 id="outcome" class="text-4xl font-bold">
        You got <%= @outcome %>!
      </h1>
      <a
        type="button"
        id="restart-quiz-button"
        class="mt-8 bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
        href={~p"/"}
      >
        Start over
      </a>
    </div>
    """
  end
end
