defmodule Quiz.Repo.Migrations.CreateQuizzes do
  use Ecto.Migration

  def change do
    create table(:quizzes) do
      add :title, :string
      add :quiz_id, references(:quizzes, on_delete: :restrict)

      timestamps()
    end
  end
end
