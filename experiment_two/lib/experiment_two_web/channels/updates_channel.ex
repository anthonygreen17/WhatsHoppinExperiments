defmodule ExperimentTwoWeb.UpdatesChannel do
  use ExperimentTwoWeb, :channel

  alias ExperimentTwo.Beer

  def join(chan, payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end

  def handle_in("message", payload, socket) do
    Beer.create_message(payload)
    new_message_id = Beer.get_latest_id!()
    payload = Map.put(payload, :id, new_message_id)
    broadcast socket, "message", payload
    {:noreply, socket}
  end

  def handle_in("delete", payload, socket) do
    msg = Beer.get_message!(payload["id"])
    Beer.delete_message(msg)
    broadcast socket, "delete", payload
    {:noreply, socket}
  end

  def handle_in("update", payload, socket) do
    msg = Beer.get_message!(payload["id"])
    Beer.update_message(msg, %{content: payload["content"]})
    broadcast socket, "update", payload
    {:noreply, socket}
  end
end
