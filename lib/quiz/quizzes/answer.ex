defmodule Quiz.Quizzes.Answer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "answers" do
    field :text, :string

    timestamps()
  end

  @doc false
  def changeset(answer, attrs) do
    answer
    |> cast(attrs, [:text])
    |> validate_required([:text])
  end
end
