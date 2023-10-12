defmodule Quiz.Quizzes.Question do
  use Ecto.Schema
  import Ecto.Changeset
  alias Quiz.Quizzes.Quiz

  schema "questions" do
    field :text, :string
    belongs_to :quiz, Quiz

    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:text])
    |> validate_required([:text])
  end
end
