defmodule RssWeb.FeedLive.Index do
  use RssWeb, :live_view

  alias Rss.Feeds
  alias Rss.Feeds.Feed

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :feeds, list_feeds())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Feed")
    |> assign(:feed, Feeds.get_feed!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Feed")
    |> assign(:feed, %Feed{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Feeds")
    |> assign(:feed, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    feed = Feeds.get_feed!(id)
    {:ok, _} = Feeds.delete_feed(feed)

    {:noreply, assign(socket, :feeds, list_feeds())}
  end

  defp list_feeds do
    Feeds.list_feeds()
  end
end
