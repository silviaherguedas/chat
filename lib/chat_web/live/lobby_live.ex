defmodule ChatWeb.LobbyLive do
  use ChatWeb, :live_view

  alias Chat.LobbyGenserver

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    LobbyGenserver.start()
    rooms = LobbyGenserver.join(self())

    socket =
      socket
      |> assign(:rooms, rooms)
      |> assign(:user, nil)

    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("new_room", value, socket) do
    IO.inspect(value, label: "LobbyLive.new_room.value")
    IO.inspect(socket.assigns, label: "LobbyLive.new_room.socket.assigns")

    LobbyGenserver.create_room(value["new_room"]["room"])

    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("new_user", value, socket) do
    socket = assign(socket, :user, value["new_user"]["username"])
    IO.inspect(value, label: "LobbyLive.new_user.value")
    IO.inspect(socket.assigns, label: "LobbyLive.new_user.socket.assigns")
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_info({:create_room, name}, socket) do
    socket = assign(socket, :rooms, MapSet.put(socket.assigns.rooms, name))

    IO.inspect(socket.assigns, label: "LobbyLive.create_room.socket.assigns")

    {:noreply, socket}
  end
end
