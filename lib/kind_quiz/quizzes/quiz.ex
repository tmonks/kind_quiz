defmodule KindQuiz.Quizzes.Quiz do
  use Ecto.Schema
  import Ecto.Changeset
  alias KindQuiz.Quizzes.Outcome
  alias KindQuiz.Quizzes.Question

  schema "quizzes" do
    field :title, :string
    field :type, Ecto.Enum, values: [:trivia, :category]

    has_many :questions, Question
    has_many :outcomes, Outcome

    timestamps()
  end

  @doc false
  def changeset(quiz, attrs) do
    quiz
    |> cast(attrs, [:title])
    |> cast_assoc(:outcomes)
    |> cast_assoc(:questions)
    |> validate_required([:title, :type])
  end
end
