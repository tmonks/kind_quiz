defmodule KindQuiz.Quizzes.Quiz do
  use Ecto.Schema
  import Ecto.Changeset
  alias KindQuiz.Quizzes.Question

  schema "quizzes" do
    field :title, :string

    has_many :questions, Question

    timestamps()
  end

  @doc false
  def changeset(quiz, attrs) do
    quiz
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
