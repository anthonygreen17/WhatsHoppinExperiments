defmodule ExperimentTwo.Beer.Style do
  use Ecto.Schema
  import Ecto.Changeset
  alias ExperimentTwo.Beer.Style


  schema "styles" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(%Style{} = style, attrs) do
    style
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
