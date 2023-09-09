defmodule QuizWeb.QuizLive do
  use QuizWeb, :live_view

  alias Quiz.Questions

  @impl true
  def mount(_params, _session, socket) do
    questions = Questions.get_questions()

    {:ok, assign(socket, questions: questions)}
  end

  @impl true
  def handle_event("submit", params, socket) do
    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container">
      <h1 class="mt-0 mb-2 text-5xl font-medium leading-tight text-primary">
        KindQuiz
      </h1>
      <form id="quiz-form" phx-submit="submit">
        <%= for {question, index} <- Enum.with_index(@questions) do %>
          <.question_component
            id={"question-#{index}"}
            text={question.text}
            answers={question.answers}
          />
        <% end %>
        <div>
          <button
            type="submit"
            class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
          >
            Submit
          </button>
        </div>
      </form>
    </div>
    """
  end

  @doc """
  Renders a question with a radio button for each answer.
  """
  def question_component(assigns) do
    ~H"""
    <div id={@id} class="pb-6">
      <div class="pb-2"><%= @text %></div>
      <%= for {answer, index} <- Enum.with_index(@answers) do %>
        <div class="pb-1">
          <label>
            <input type="radio" name={@id} value={index} />
            <span><%= answer %></span>
          </label>
        </div>
      <% end %>
    </div>
    """
  end
end
