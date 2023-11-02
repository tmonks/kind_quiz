defmodule KindQuiz.Repo.Migrations.CreateAnswers do
  use Ecto.Migration

  def change do
    create table(:answers) do
      add :text, :string, null: false
      add :number, :integer, null: false
      add :question_id, references(:questions, on_delete: :restrict), null: false

      timestamps()
    end

    create unique_index(:answers, [:question_id, :number])
  end
end
