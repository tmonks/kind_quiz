defmodule KindQuiz.Repo.Migrations.AddFieldsForTriviaQuizzes do
  use Ecto.Migration

  def change do
    alter table(:quizzes) do
      add :type, :string
    end

    alter table(:questions) do
      add :correct, :integer
      add :explanation, :string
    end
  end
end
