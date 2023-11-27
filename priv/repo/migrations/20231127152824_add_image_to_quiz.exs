defmodule KindQuiz.Repo.Migrations.AddImageToQuiz do
  use Ecto.Migration

  def change do
    alter table(:quizzes) do
      add :image, :string
      add :image_prompt, :string
    end
  end
end
