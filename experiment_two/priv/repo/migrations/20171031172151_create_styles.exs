defmodule ExperimentTwo.Repo.Migrations.CreateStyles do
  use Ecto.Migration

  def change do
    create table(:styles) do
      add :name, :string

      timestamps()
    end

  end
end
