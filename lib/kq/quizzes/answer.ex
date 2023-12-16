defmodule KQ.Quizzes.Answer do
  use Ecto.Schema
  import Ecto.Changeset
  alias KQ.Quizzes.Question

  schema "answers" do
    field :text, :string
    field :number, :integer
    belongs_to :question, Question

    timestamps()
  end

  @doc false
  def changeset(answer, attrs) do
    answer
    |> cast(attrs, [:text, :number])
    |> validate_required([:text, :number])
  end
end
