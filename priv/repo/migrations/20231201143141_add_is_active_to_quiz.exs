defmodule KindQuiz.Repo.Migrations.AddIsActiveToQuiz do
  use Ecto.Migration

  def change do
    alter table(:quizzes) do
      add :is_active, :boolean, default: false
    end

    execute("UPDATE quizzes SET is_active = false", "")
  end
end
