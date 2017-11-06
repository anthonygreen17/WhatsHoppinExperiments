defmodule ExperimentTwo.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :content, :string
      add :style_id, references(:styles, on_delete: :nothing)

      timestamps()
    end

    create index(:messages, [:style_id])
  end
end
