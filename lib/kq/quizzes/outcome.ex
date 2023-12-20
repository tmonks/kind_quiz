defmodule KQ.Quizzes.Outcome do
  use Ecto.Schema
  import Ecto.Changeset
  alias KQ.Quizzes.Quiz

  schema "outcomes" do
    field :text, :string
    field :image, :string
    field :number, :integer
    field :image_prompt, :string
    field :description, :string
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
