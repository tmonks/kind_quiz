defmodule KindQuizWeb.OutcomeLive do
  use KindQuizWeb, :live_view

  alias KindQuiz.Questions

  def handle_params(%{"id" => quiz_id, "number" => number}, _uri, socket) do
    quiz_id = String.to_integer(quiz_id)
    number = String.to_integer(number)
    outcome = Questions.get_outcome!(quiz_id, number)

    {:noreply, socket |> assign(outcome: outcome)}
  end

  def render(assigns) do
    ~H"""
    <div class="mt-28 mt-2 text-center">
      <h1 id="outcome" class="text-4xl font-bold">
        <%= @outcome.text %>!
      </h1>
      <%= if @outcome.image do %>
        <img src={~p"/images/#{@outcome.image}"} class="mt-8 mx-auto" style="max-height: 700px" />
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
