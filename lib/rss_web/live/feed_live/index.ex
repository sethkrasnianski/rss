defmodule RssWeb.FeedLive.Index do
  use RssWeb, :live_view

  alias Rss.Feeds
  alias Rss.UserFeeds
  alias Rss.Feeds.Feed

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :feeds, list_feeds(socket.assigns.current_user.id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Feed")
    |> assign(:feed, UserFeeds.get_feed!(socket.assigns.current_user.id, id))
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
    user_id = socket.assigns.current_user.id
    feed = UserFeeds.get_feed!(user_id, id)
    {:ok, _} = Feeds.delete_feed(feed)

    {:noreply, assign(socket, :feeds, list_feeds(user_id))}
  end

  defp list_feeds(user_id) do
    UserFeeds.list_feeds(user_id)
  end
end
