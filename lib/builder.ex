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
  def build_trivia_quiz(title) do
    {:ok, image_prompt} = Generator.generate_image_prompt(title)
    {:ok, quiz} = Quizzes.create_trivia_quiz(%{title: title, image_prompt: image_prompt})

    add_image(quiz)

    Enum.each(1..10, fn _ -> add_trivia_question(quiz) end)

    {:ok, Repo.reload(quiz) |> Repo.preload(:questions)}
  end

  @doc """
  Generates and adds an image to a quiz or an outcome
  """
  def add_image(%Quiz{image_prompt: prompt} = quiz) when not is_nil(prompt) do
    {:ok, filename} = Api.generate_image(quiz.image_prompt)

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
  def build_category_quiz(title, options \\ []) do
    defaults = %{outcomes: 5}
    options = options |> Enum.into(defaults)

    # TODO: make outcome_image_prompt optional
    outcome_image_prompt = Map.fetch!(options, :outcome_image_prompt)
    outcomes = Map.get(options, :outcomes)

    # generate the quiz, outcomes and questions
    attrs = Generator.generate_category_quiz(title, outcomes)

    # generate an image prompt for the quiz itself and add to attrs
    {:ok, image_prompt} = Generator.generate_image_prompt(title)
    attrs = Map.put(attrs, "image_prompt", image_prompt)

    # create the quiz
    {:ok, quiz} = Quizzes.create_category_quiz(attrs)

    # generate and add cover image
    {:ok, quiz} = add_image(quiz)

    # set outcome image prompts on the quiz outcomes
    {:ok, quiz} = Quizzes.set_outcome_image_prompts(quiz, outcome_image_prompt)

    # add image to each outcome
    Enum.each(quiz.outcomes, fn outcome -> add_image(outcome) end)

    # return reloaded quiz
    {:ok, Repo.reload(quiz) |> Repo.preload([:outcomes, :questions])}
  end
end
