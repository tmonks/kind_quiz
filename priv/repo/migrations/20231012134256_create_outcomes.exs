defmodule KindQuiz.Repo.Migrations.CreateOutcomes do
  use Ecto.Migration

  def change do
    create table(:outcomes) do
      add :text, :string
      add :image_file_name, :string
      add :quiz_id, references(:quizzes, on_delete: :restrict)

      timestamps()
    end
  end
end
