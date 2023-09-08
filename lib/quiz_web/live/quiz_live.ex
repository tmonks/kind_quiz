defmodule QuizWeb.QuizLive do
  use QuizWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, answer: "42")}
  end

  @impl true
  def handle_event("submit", params, socket) do
    IO.inspect(params)
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
        <!-- quiz question with radio button with answers a, b, c, and d -->
        <.question_component
          id={1}
          text="What is your favorite subject in school?"
          answers={["A", "B", "C", "D"]}
        />
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
    <div id="question-1">
      <%= @text %>
      <%= for {answer, index} <- Enum.with_index(@answers) do %>
        <div>
          <label>
            <input type="radio" name="question-1" value={index} />
            <span><%= answer %></span>
          </label>
        </div>
      <% end %>
    </div>
    """
  end
end
