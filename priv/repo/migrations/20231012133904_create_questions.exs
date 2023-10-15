defmodule KindQuiz.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add :text, :string
      add :quiz_id, references(:quizzes, on_delete: :restrict)

      timestamps()
    end
  end
end
