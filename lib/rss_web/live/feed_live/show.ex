defmodule RssWeb.FeedLive.Show do
  use RssWeb, :live_view

  alias Rss.Feeds

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:feed, Feeds.get_feed!(id))}
  end

  defp page_title(:show), do: "Show Feed"
  defp page_title(:edit), do: "Edit Feed"
end
