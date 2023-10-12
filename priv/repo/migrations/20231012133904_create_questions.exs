defmodule Quiz.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add :text, :string

      timestamps()
    end
  end
end
