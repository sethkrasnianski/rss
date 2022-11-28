defmodule Rss.FeedsFixtures do
  import Rss.AccountsFixtures

  @moduledoc """
  This module defines test helpers for creating
  entities via the `Rss.Feeds` context.
  """

  @doc """
  Generate a feed.
  """
  def feed_fixture(attrs \\ %{}) do
    user_id = case attrs do
      %{user_id: user_id} -> user_id
      %{user: user} -> user.id
      _ -> user_fixture().id
    end

    {:ok, feed} =
      attrs
      |> Enum.into(%{
        description: "some description",
        feed_url: "some feed_url",
        icon_url: "some icon_url",
        title: "some title",
        user_id: user_id
      })
      |> Rss.Feeds.create_feed()

    feed
  end
end
