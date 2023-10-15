defmodule KindQuiz.Repo.Migrations.CreateOutcomes do
  use Ecto.Migration

  def change do
    create table(:outcomes) do
      add :text, :string
      add :image_file_name, :string

      timestamps()
    end
  end
end
