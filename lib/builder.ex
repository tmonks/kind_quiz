defmodule KQ.Builder do
  alias KQ.Quizzes
  alias KQ.Quizzes.Outcome
  alias KQ.Quizzes.Question
  alias KQ.Quizzes.Quiz
  alias KQ.Generator
  alias KQ.Repo
  alias KQ.StabilityAi.Api

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
  Generates and adds an image to a quiz or an outcome
  """
  def add_image(%Quiz{} = quiz) do
    {:ok, filename, prompt} = Generator.generate_image(quiz)

    quiz
    |> Ecto.Changeset.change(%{image: filename, image_prompt: prompt})
    |> Repo.update()
  end

  def add_image(%Outcome{image_prompt: image_prompt} = outcome) when not is_nil(image_prompt) do
    {:ok, filename} = Api.generate_image(image_prompt)

    outcome
    |> Ecto.Changeset.change(%{image: filename})
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

  @doc """
  Adds an image to each outcome of a category quiz
  """
  def add_outcome_images(%Quiz{} = quiz) do
    quiz = Repo.preload(quiz, :outcomes)
    Enum.each(quiz.outcomes, fn outcome -> add_image(outcome) end)

    quiz = quiz |> Repo.reload() |> Repo.preload(:outcomes)
    {:ok, quiz}
  end

  @doc """
  Builds a category quiz with outcomes, questions, and images
  """
  def build_category_quiz(title) do
    Quizzes.create_category_quiz(title)

    # add_image(quiz)

    # Add outcomes

    # Add questions
    # Enum.each(1..5, fn _ -> add_category_question(quiz) end)

    # Repo.reload(quiz) |> Repo.preload(:questions)
  end
end
