defmodule ExperimentTwo.Beer.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias ExperimentTwo.Beer.Message


  schema "messages" do
    field :content, :string
    field :style_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Message{} = message, attrs) do
    message
    |> cast(attrs, [:content, :style_id])
    |> validate_required([:content, :style_id])
  end
end
