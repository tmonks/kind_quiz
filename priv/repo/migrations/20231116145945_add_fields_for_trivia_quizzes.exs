defmodule KindQuiz.Repo.Migrations.AddFieldsForTriviaQuizzes do
  use Ecto.Migration

  def change do
    alter table(:quizzes) do
      add :type, :string, null: false, default: "category"
    end

    alter table(:questions) do
      add :correct, :integer
      add :explanation, :string
    end
  end
end
