defmodule Quiz.Quizzes.Answer do
  use Ecto.Schema
  import Ecto.Changeset
  alias Quiz.Quizzes.Question
  alias Quiz.Quizzes.Outcome

  schema "answers" do
    field :text, :string
    belongs_to :question, Question
    belongs_to :outcome, Outcome

    timestamps()
  end

  @doc false
  def changeset(answer, attrs) do
    answer
    |> cast(attrs, [:text])
    |> validate_required([:text])
  end
end
