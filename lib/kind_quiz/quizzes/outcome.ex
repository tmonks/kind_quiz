defmodule KindQuiz.Quizzes.Outcome do
  use Ecto.Schema
  import Ecto.Changeset
  alias KindQuiz.Quizzes.Quiz

  schema "outcomes" do
    field :text, :string
    field :image, :string
    field :number, :integer
    belongs_to :quiz, Quiz

    timestamps()
  end

  @doc false
  def changeset(outcome, attrs) do
    outcome
    |> cast(attrs, [:text, :image, :number])
    |> validate_required([:text, :number])
  end
end
