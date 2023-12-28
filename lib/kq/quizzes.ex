defmodule KQ.Quizzes do
  @moduledoc """
  Loads quiz and questions data
  """

  import Ecto.Query
  import Ecto.Changeset, only: [cast_assoc: 3]

  alias KQ.Repo
  alias KQ.Quizzes.Outcome
  alias KQ.Quizzes.Quiz

  @doc """
  Creates a new trivia quiz with the given title.
  """
  def create_trivia_quiz(title) do
    %Quiz{}
    |> Quiz.changeset(%{title: title, type: :trivia})
    |> Repo.insert()
  end

  @doc """
  Creates a new category quiz with the given title.
  """
  def create_category_quiz(title) do
    %Quiz{}
    |> Quiz.changeset(%{title: title, type: :category})
    |> Repo.insert()
  end

  @doc """
  Toggles the is_active flag for the given quiz.
  """
  def toggle_active(quiz) do
    quiz
    |> Quiz.changeset(%{is_active: !quiz.is_active})
    |> Repo.update()
  end

  @doc """
  Returns a quiz by id. Raises an error if the id is invalid.
  """
  def get_quiz!(id) do
    Repo.get!(Quiz, id)
    |> Repo.preload(questions: :answers)
  end

  @doc """
  Returns a list of all quizzes sorted by newest first.
  """
  def list_quizzes do
    from(q in Quiz,
      order_by: [desc: q.inserted_at]
    )
    |> Repo.all()
  end

  @doc """
  Returns a list of all active quizzes sorted by newest first
  """
  def list_active_quizzes do
    from(q in Quiz,
      where: q.is_active == true,
      order_by: [desc: q.inserted_at]
    )
    |> Repo.all()
  end

  @doc """
  Returns the outcome with the given id. Raises an error if the id is invalid.
  """
  def get_outcome!(id) do
    Repo.get!(Outcome, id)
  end

  @doc """
  Returns the outcome with the given quiz_id and number. Raises an error if the id is invalid.
  """
  def get_outcome!(quiz_id, number) do
    Repo.get_by!(Outcome, quiz_id: quiz_id, number: number)
  end

  @doc """
  Gets the oldest quiz with less than 10 questions.
  """
  def get_incomplete_quiz do
    from(q in Quiz,
      where: fragment("SELECT COUNT(*) FROM questions WHERE questions.quiz_id = ? ", q.id) < 10,
      where: q.type == :trivia,
      order_by: [asc: q.inserted_at],
      limit: 1
    )
    |> Repo.one()
  end

  @doc """
  Lists quizzes with no questions
  """
  def list_empty_quizzes do
    from(q in Quiz,
      where: fragment("SELECT COUNT(*) FROM questions WHERE questions.quiz_id = ? ", q.id) == 0,
      order_by: [asc: q.inserted_at]
    )
    |> Repo.all()
  end

  @doc """
  Adds a set of outcomes to a quiz

  ## Examples

    iex> add_outcomes(quiz, [%{"text" => "Outcome 1", "description" => "Description 1", "number" => 1}])
    {:ok, %Quiz{}}
  """
  def add_outcomes(quiz, outcomes) do
    quiz
    |> Repo.preload(:outcomes)
    |> Ecto.Changeset.cast(%{"outcomes" => outcomes}, [])
    |> cast_assoc(:outcomes, with: &Outcome.changeset/2)
    |> Repo.update()
  end

  @doc """
  Sets the image_prompt for each of the outcomes on a quiz
  Replaces {{outcome}} with the outcome's text
  """
  def set_outcome_image_prompts(quiz, image_prompt) do
    %{outcomes: outcomes} =
      Repo.preload(quiz, :outcomes)

    Enum.each(outcomes, &update_image_prompt(&1, image_prompt))

    {:ok, Repo.preload(quiz, :outcomes, force: true)}
  end

  defp update_image_prompt(outcome, image_prompt) do
    image_prompt = fill_placeholders(outcome, image_prompt)

    outcome
    |> Ecto.Changeset.change(%{image_prompt: image_prompt})
    |> Repo.update()
  end

  defp fill_placeholders(outcome, image_prompt) do
    String.replace(image_prompt, "{{outcome}}", outcome.text)
  end
end
