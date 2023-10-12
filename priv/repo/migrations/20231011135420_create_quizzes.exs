defmodule Quiz.Repo.Migrations.CreateQuizzes do
  use Ecto.Migration

  def change do
    create table(:quizzes) do
      add :title, :string

      timestamps()
    end
  end
end
