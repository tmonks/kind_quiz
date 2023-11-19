defmodule KindQuiz.Repo.Migrations.CreateOutcomes do
  use Ecto.Migration

  def change do
    create table(:outcomes) do
      add :text, :string, null: false
      add :number, :integer, null: false
      add :image, :string
      add :quiz_id, references(:quizzes, on_delete: :cascade), null: false

      timestamps()
    end

    create unique_index(:outcomes, [:quiz_id, :number])
  end
end
