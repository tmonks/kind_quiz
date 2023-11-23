defmodule KindQuiz.Quizzes do
  @moduledoc """
  Loads quiz and questions data
  """

  import Ecto.Query

  alias KindQuiz.Repo
  alias KindQuiz.Quizzes.Outcome
  alias KindQuiz.Quizzes.Quiz

  @doc """
  Creates a new trivia quiz with the given title.
  """
  def create_trivia_quiz(title) do
    %Quiz{}
    |> Quiz.changeset(%{title: title, type: :trivia})
    |> Repo.insert()
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
end
