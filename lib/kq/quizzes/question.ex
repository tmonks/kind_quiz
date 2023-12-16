defmodule KQ.Quizzes.Question do
  use Ecto.Schema
  import Ecto.Changeset
  alias KQ.Quizzes.Answer
  alias KQ.Quizzes.Quiz

  schema "questions" do
    field :text, :string
    field :correct, :integer
    field :explanation, :string
    belongs_to :quiz, Quiz
    has_many :answers, Answer

    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:text, :quiz_id, :correct, :explanation])
    |> validate_required([:text])
    |> cast_assoc(:answers)
  end
end
