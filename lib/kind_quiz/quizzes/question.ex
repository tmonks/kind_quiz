defmodule KindQuiz.Quizzes.Question do
  use Ecto.Schema
  import Ecto.Changeset
  alias KindQuiz.Quizzes.Answer
  alias KindQuiz.Quizzes.Quiz

  schema "questions" do
    field :text, :string
    belongs_to :quiz, Quiz
    has_many :answers, Answer

    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:text])
    |> validate_required([:text])
  end
end
