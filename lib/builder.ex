defmodule KQ.Builder do
  alias KQ.Quizzes
  alias KQ.Quizzes.Question
  alias KQ.Generator
  alias KQ.Repo

  @doc """
  Populates questions for brand new trivia quizzes
  """
  def create_trivia_quiz(title) do
    {:ok, quiz} = Quizzes.create_trivia_quiz(title)

    add_image(quiz)

    Enum.each(1..10, fn _ -> add_trivia_question(quiz) end)

    Repo.reload(quiz) |> Repo.preload(:questions)
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

  @doc """
  Generates and inserts a question to a trivia quiz
  """
  def add_trivia_question(quiz) do
    Generator.generate_trivia_question(quiz)
    |> create_question_changeset(quiz)
    |> Repo.insert()
    |> IO.inspect()
  end

  defp create_question_changeset(attrs, quiz) do
    Question.changeset(%Question{}, attrs)
    |> Ecto.Changeset.put_change(:quiz_id, quiz.id)
  end
end
