defmodule Quiz.Repo.Migrations.CreateAnswers do
  use Ecto.Migration

  def change do
    create table(:answers) do
      add :text, :string
      add :question_id, references(:questions, on_delete: :restrict)
      add :outcome_id, references(:outcomes, on_delete: :restrict)

      timestamps()
    end
  end
end
