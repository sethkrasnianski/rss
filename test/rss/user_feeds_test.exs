defmodule Rss.UserFeedsTest do
  use Rss.DataCase

  alias Rss.UserFeeds

  describe "feeds" do
    import Rss.FeedsFixtures
    import Rss.AccountsFixtures

    test "list_feeds/0 returns all feeds" do
      user = user_fixture()
      feed = feed_fixture(%{user: user})

      assert UserFeeds.list_feeds(user.id) == [feed]
    end

    test "get_feed!/1 returns the feed with given id" do
      user = user_fixture()
      feed = feed_fixture(%{user: user})

      assert UserFeeds.get_feed!(user.id, feed.id) == feed
    end
  end
end
