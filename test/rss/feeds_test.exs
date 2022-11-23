defmodule Rss.FeedsTest do
  use Rss.DataCase

  alias Rss.Feeds

  describe "feeds" do
    alias Rss.Feeds.Feed

    import Rss.FeedsFixtures
    import Rss.AccountsFixtures

    @invalid_attrs %{description: nil, feed_url: nil, icon_url: nil, title: nil, user_id: nil}

    test "list_feeds/0 returns all feeds" do
      feed = feed_fixture()
      assert Feeds.list_feeds() == [feed]
    end

    test "get_feed!/1 returns the feed with given id" do
      feed = feed_fixture()
      assert Feeds.get_feed!(feed.id) == feed
    end

    test "create_feed/1 with valid data creates a feed" do
      %{id: user_id} = user_fixture()

      valid_attrs = %{
        description: "some description",
        feed_url: "some feed_url",
        icon_url: "some icon_url",
        title: "some title",
        user_id: user_id
      }

      assert {:ok, %Feed{} = feed} = Feeds.create_feed(valid_attrs)
      assert feed.description == "some description"
      assert feed.feed_url == "some feed_url"
      assert feed.icon_url == "some icon_url"
      assert feed.title == "some title"
    end

    test "create_feed/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Feeds.create_feed(@invalid_attrs)
    end

    test "update_feed/2 with valid data updates the feed" do
      feed = feed_fixture()

      update_attrs = %{
        description: "some updated description",
        feed_url: "some updated feed_url",
        icon_url: "some updated icon_url",
        title: "some updated title"
      }

      assert {:ok, %Feed{} = feed} = Feeds.update_feed(feed, update_attrs)
      assert feed.description == "some updated description"
      assert feed.feed_url == "some updated feed_url"
      assert feed.icon_url == "some updated icon_url"
      assert feed.title == "some updated title"
    end

    test "update_feed/2 with invalid data returns error changeset" do
      feed = feed_fixture()
      assert {:error, %Ecto.Changeset{}} = Feeds.update_feed(feed, @invalid_attrs)
      assert feed == Feeds.get_feed!(feed.id)
    end

    test "delete_feed/1 deletes the feed" do
      feed = feed_fixture()
      assert {:ok, %Feed{}} = Feeds.delete_feed(feed)
      assert_raise Ecto.NoResultsError, fn -> Feeds.get_feed!(feed.id) end
    end

    test "change_feed/1 returns a feed changeset" do
      feed = feed_fixture()
      assert %Ecto.Changeset{} = Feeds.change_feed(feed)
    end
  end
end
