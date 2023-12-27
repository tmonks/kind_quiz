defmodule KQWeb.OutcomeLive do
  use KQWeb, :live_view

  alias KQ.Quizzes
  alias KQ.Repo

  def handle_params(%{"id" => quiz_id, "number" => number}, _uri, socket) do
    quiz_id = String.to_integer(quiz_id)
    number = String.to_integer(number)
    outcome = Quizzes.get_outcome!(quiz_id, number) |> Repo.preload(:quiz)

    socket = socket |> assign(quiz: outcome.quiz) |> assign(outcome: outcome)

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="mt-2 text-center">
      <h1 id="quiz-title" class="mt-0 mb-8 text-4xl font-medium leading-tight text-primary">
        <%= @quiz.title %>
      </h1>
      <h2 id="outcome" class="text-4xl font-bold">
        <%= @outcome.text %>!
      </h2>
      <%= if @outcome.image do %>
        <img src={~p"/images/quiz/#{@outcome.image}"} class="mt-8 mx-auto" style="max-height: 700px" />
      <% end %>
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
