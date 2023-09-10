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
    <div>
      <h1 id="outcome" class="mt-0 mb-2 text-5xl font-medium leading-tight text-primary">
        You got <%= @outcome %>!
      </h1>
    </div>
    """
  end
end
