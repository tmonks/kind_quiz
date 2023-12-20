defmodule KQ.Repo.Migrations.AddDescriptionAndImagePromptToOutcomes do
  use Ecto.Migration

  def change do
    alter table(:outcomes) do
      add :description, :string
      add :image_prompt, :string
    end
  end
end
