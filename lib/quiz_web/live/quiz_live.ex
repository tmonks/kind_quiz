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
        <div class="question">
          What is your favorite movie?
          <div>
            <label>
              <input type="radio" name="question1" value="a" />
              <span>Answer A</span>
            </label>
          </div>
          <div>
            <label>
              <input type="radio" name="question1" value="b" />
              <span>Answer B</span>
            </label>
          </div>
          <div>
            <label>
              <input type="radio" name="question1" value="c" />
              <span>Answer C</span>
            </label>
          </div>
          <div>
            <label>
              <input type="radio" name="question1" value="c" />
              <span>Answer D</span>
            </label>
          </div>
        </div>
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
end
