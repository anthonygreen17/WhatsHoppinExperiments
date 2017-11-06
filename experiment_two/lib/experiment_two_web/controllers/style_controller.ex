defmodule ExperimentTwoWeb.StyleController do
  use ExperimentTwoWeb, :controller

  alias ExperimentTwo.Beer
  alias ExperimentTwo.Beer.Style
  alias ExperimentTwo.Beer.Message

  def index(conn, _params) do
    styles = Beer.list_styles()
    render(conn, "index.html", styles: styles)
  end

  def new(conn, _params) do
    changeset = Beer.change_style(%Style{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"style" => style_params}) do
    case Beer.create_style(style_params) do
      {:ok, style} ->
        conn
        |> put_flash(:info, "Style created successfully.")
        |> redirect(to: style_path(conn, :show, style))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    style = Beer.get_style!(id)
    message = Beer.change_message(%Message{content: "", style_id: id})
    messages = Beer.list_messages_for_style(id)
    render(conn, "show.html", style: style, messages: messages, message: message)
  end

  def edit(conn, %{"id" => id}) do
    style = Beer.get_style!(id)
    changeset = Beer.change_style(style)
    render(conn, "edit.html", style: style, changeset: changeset)
  end

  def update(conn, %{"id" => id, "style" => style_params}) do
    style = Beer.get_style!(id)

    case Beer.update_style(style, style_params) do
      {:ok, style} ->
        conn
        |> put_flash(:info, "Style updated successfully.")
        |> redirect(to: style_path(conn, :show, style))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", style: style, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    style = Beer.get_style!(id)
    {:ok, _style} = Beer.delete_style(style)

    conn
    |> put_flash(:info, "Style deleted successfully.")
    |> redirect(to: style_path(conn, :index))
  end
end
