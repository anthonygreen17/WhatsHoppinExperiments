defmodule ExperimentTwo.Beer do
  @moduledoc """
  The Beer context.
  """

  import Ecto.Query, warn: false
  alias ExperimentTwo.Repo

  alias ExperimentTwo.Beer.Style

  @doc """
  Returns the list of styles.

  ## Examples

      iex> list_styles()
      [%Style{}, ...]

  """
  def list_styles do
    Repo.all(Style)
  end

  @doc """
  Gets a single style.

  Raises `Ecto.NoResultsError` if the Style does not exist.

  ## Examples

      iex> get_style!(123)
      %Style{}

      iex> get_style!(456)
      ** (Ecto.NoResultsError)

  """
  def get_style!(id), do: Repo.get!(Style, id)

  @doc """
  Creates a style.

  ## Examples

      iex> create_style(%{field: value})
      {:ok, %Style{}}

      iex> create_style(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_style(attrs \\ %{}) do
    %Style{}
    |> Style.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a style.

  ## Examples

      iex> update_style(style, %{field: new_value})
      {:ok, %Style{}}

      iex> update_style(style, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_style(%Style{} = style, attrs) do
    style
    |> Style.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Style.

  ## Examples

      iex> delete_style(style)
      {:ok, %Style{}}

      iex> delete_style(style)
      {:error, %Ecto.Changeset{}}

  """
  def delete_style(%Style{} = style) do
    Repo.delete(style)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking style changes.

  ## Examples

      iex> change_style(style)
      %Ecto.Changeset{source: %Style{}}

  """
  def change_style(%Style{} = style) do
    Style.changeset(style, %{})
  end

  alias ExperimentTwo.Beer.Message

  @doc """
  Returns the list of messages.

  ## Examples

      iex> list_messages()
      [%Message{}, ...]

  """
  def list_messages do
    Repo.all(Message)
  end

  def list_messages_for_style(style_id) do
    query = from m in Message,
          where: m.style_id == ^style_id,
          select: m

    Repo.all(query)
  end

  @doc """
  Gets a single message.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> get_message!(123)
      %Message{}

      iex> get_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message!(id), do: Repo.get!(Message, id)

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a message.

  ## Examples

      iex> update_message(message, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Message.

  ## Examples

      iex> delete_message(message)
      {:ok, %Message{}}

      iex> delete_message(message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{source: %Message{}}

  """
  def change_message(%Message{} = message) do
    Message.changeset(message, %{})
  end
end
