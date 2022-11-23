defmodule RssWeb.FeedLiveTest do
  use RssWeb.ConnCase

  import Phoenix.LiveViewTest
  import Rss.FeedsFixtures
  import Rss.AccountsFixtures

  @create_attrs %{
    description: "some description",
    feed_url: "some feed_url",
    icon_url: "some icon_url",
    title: "some title"
  }
  @update_attrs %{
    description: "some updated description",
    feed_url: "some updated feed_url",
    icon_url: "some updated icon_url",
    title: "some updated title"
  }
  @invalid_attrs %{description: nil, feed_url: nil, icon_url: nil, title: nil}

  defp create_feed(_) do
    feed = feed_fixture()
    %{feed: feed}
  end

  describe "Redirects" do
    setup [:create_feed]

    test "from index user is not logged in", %{conn: conn} do
      assert {:error, redirect} = live(conn, ~p"/feeds")

      assert {:redirect, %{to: path, flash: flash}} = redirect
      assert path == ~p"/users/log_in"
      assert %{"error" => "You must log in to access this page."} = flash
    end

    test "from show if user is not logged in", %{conn: conn, feed: feed} do
      assert {:error, redirect} = live(conn, ~p"/feeds/#{feed}")

      assert {:redirect, %{to: path, flash: flash}} = redirect
      assert path == ~p"/users/log_in"
      assert %{"error" => "You must log in to access this page."} = flash
    end
  end

  describe "Index" do
    setup [:create_feed]

    setup %{conn: conn} do
      password = valid_user_password()
      user = user_fixture(%{password: password})
      %{conn: log_in_user(conn, user), user: user, password: password}
    end

    test "lists all feeds", %{conn: conn, feed: feed} do
      {:ok, _index_live, html} = live(conn, ~p"/feeds")

      assert html =~ "Listing Feeds"
      assert html =~ feed.description
    end

    test "saves new feed", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/feeds")

      assert index_live |> element("a", "New Feed") |> render_click() =~
               "New Feed"

      assert_patch(index_live, ~p"/feeds/new")

      assert index_live
             |> form("#feed-form", feed: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#feed-form", feed: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/feeds")

      assert html =~ "Feed created successfully"
      assert html =~ "some description"
    end

    test "updates feed in listing", %{conn: conn, feed: feed} do
      {:ok, index_live, _html} = live(conn, ~p"/feeds")

      assert index_live |> element("#feeds-#{feed.id} a", "Edit") |> render_click() =~
               "Edit Feed"

      assert_patch(index_live, ~p"/feeds/#{feed}/edit")

      assert index_live
             |> form("#feed-form", feed: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#feed-form", feed: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/feeds")

      assert html =~ "Feed updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes feed in listing", %{conn: conn, feed: feed} do
      {:ok, index_live, _html} = live(conn, ~p"/feeds")

      assert index_live |> element("#feeds-#{feed.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#feed-#{feed.id}")
    end
  end

  describe "Show" do
    setup [:create_feed]

    setup %{conn: conn} do
      password = valid_user_password()
      user = user_fixture(%{password: password})
      %{conn: log_in_user(conn, user), user: user, password: password}
    end

    test "displays feed", %{conn: conn, feed: feed} do
      {:ok, _show_live, html} = live(conn, ~p"/feeds/#{feed}")

      assert html =~ "Show Feed"
      assert html =~ feed.description
    end

    test "updates feed within modal", %{conn: conn, feed: feed} do
      {:ok, show_live, _html} = live(conn, ~p"/feeds/#{feed}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Feed"

      assert_patch(show_live, ~p"/feeds/#{feed}/show/edit")

      assert show_live
             |> form("#feed-form", feed: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#feed-form", feed: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/feeds/#{feed}")

      assert html =~ "Feed updated successfully"
      assert html =~ "some updated description"
    end
  end
end
