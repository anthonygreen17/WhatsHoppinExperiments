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

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  # def handle_in("ping", payload, socket) do
  #   {:reply, {:ok, payload}, socket}
  # end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (updates:lobby).
  # def handle_in("shout", payload, socket) do
  #   broadcast socket, "shout", payload
  #   {:noreply, socket}
  # end

  def handle_in("message", payload, socket) do
    broadcast socket, "message", payload
    {:noreply, socket}
    Beer.create_message(payload)
  end

  def handle_in("delete", payload, socket) do
    Beer.delete_message(Beer.get_message!(payload["id"]));
    {:noreply, socket}
  end
end
