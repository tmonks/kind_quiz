defmodule KindQuiz.Builder do
  use GenServer

  alias KindQuiz.Quizzes
  alias KindQuiz.Generator

  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{})
  end

  @impl true
  def init(state) do
    schedule_creation()
    {:ok, state}
  end

  @impl true
  def handle_info(:create, state) do
    quiz = Quizzes.get_incomplete_quiz()

    if not is_nil(quiz) do
      IO.puts("Generating question for: #{quiz.title}")
      {:ok, %{text: text}} = Generator.generate_trivia_question(quiz)
      IO.puts("Generated question: #{text}")
    end

    schedule_creation()

    {:noreply, state}
  end

  defp schedule_creation() do
    Process.send_after(self(), :create, 10_000)
  end
end
