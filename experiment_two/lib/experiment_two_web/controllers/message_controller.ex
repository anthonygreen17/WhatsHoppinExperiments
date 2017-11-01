defmodule ExperimentTwoWeb.MessageController do
  use ExperimentTwoWeb, :controller

  alias ExperimentTwo.Beer
  alias ExperimentTwo.Beer.Message

  # def index(conn, _params) do
  #   messages = Beer.list_messages()
  #   render(conn, "index.html", messages: messages)
  # end

  def new(conn, _params) do
    changeset = Beer.change_message(%Message{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"message" => message_params}) do
    case Beer.create_message(message_params) do
      {:ok, message} ->
        conn
        |> put_flash(:info, "Message created successfully.")
        |> redirect(to: style_path(conn, :show, message.style_id))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  # def show(conn, %{"id" => id}) do
  #   message = Beer.get_message!(id)
  #   render(conn, "show.html", message: message)
  # end

  def edit(conn, %{"id" => id}) do
    message = Beer.get_message!(id)
    changeset = Beer.change_message(message)
    render(conn, "edit.html", message: message, changeset: changeset)
  end

  def update(conn, %{"id" => id, "message" => message_params}) do
    message = Beer.get_message!(id)

    case Beer.update_message(message, message_params) do
      {:ok, message} ->
        conn
        |> put_flash(:info, "Message updated successfully.")
        |> redirect(to: style_path(conn, :show, Beer.get_style!(message.style_id)))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", message: message, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    message = Beer.get_message!(id)
    {:ok, _message} = Beer.delete_message(message)

    conn
    |> put_flash(:info, "Message deleted successfully.")
    |> redirect(to: message_path(conn, :index))
  end
end
