defmodule KindQuiz.Builder do
  use GenServer

  alias KindQuiz.Quizzes
  alias KindQuiz.Generator
  alias KindQuiz.Repo

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
    empty_quizzes = Quizzes.list_empty_quizzes() |> Enum.filter(&(&1.type == :trivia))

    if empty_quizzes != [] do
      quiz = Enum.at(empty_quizzes, 0)
      IO.puts("Generating questions for: #{quiz.title}")
      Enum.each(1..10, fn _ -> create_question(quiz) end)
    end

    schedule_creation()

    {:noreply, state}
  end

  @doc """
  Generates and adds an image to a quiz
  """
  def add_image(quiz) do
    {:ok, filename, prompt} = Generator.generate_image(quiz)

    quiz
    |> Ecto.Changeset.change(%{image: filename, image_prompt: prompt})
    |> Repo.update()
  end

  defp create_question(quiz) do
    {:ok, %{text: text}} = Generator.generate_trivia_question(quiz)
    IO.puts("Generated question: #{text}")
  end

  defp schedule_creation() do
    Process.send_after(self(), :create, 10_000)
  end
end
