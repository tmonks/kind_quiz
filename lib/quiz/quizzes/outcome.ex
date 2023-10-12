defmodule Quiz.Quizzes.Outcome do
  use Ecto.Schema
  import Ecto.Changeset

  schema "outcomes" do
    field :text, :string
    field :image_file_name, :string

    timestamps()
  end

  @doc false
  def changeset(outcome, attrs) do
    outcome
    |> cast(attrs, [:text, :image_file_name])
    |> validate_required([:text, :image_file_name])
  end
end
