defmodule Rss.UserFeeds do
  @moduledoc """
  A context to enable interaction of feeds based on a particular user.
  """

  import Ecto.Query, warn: false
  alias Rss.Repo

  alias Rss.Feeds.Feed

  @doc """
  Returns the list of feeds for a particular user.

  ## Examples

      iex> list_feeds(1)
      [%Feed{}, ...]

  """
  def list_feeds(user_id) do
    Repo.all(
      from(
        f in Feed,
        where: f.user_id == ^user_id
      )
    )
  end

  @doc """
  Gets a single feed by user.

  Raises `Ecto.NoResultsError` if the Feed does not exist.

  ## Examples

      iex> get_feed!(1, 123)
      %Feed{}

      iex> get_feed!(1, 456)
      ** (Ecto.NoResultsError)

  """
  def get_feed!(user_id, feed_id) do
    Repo.one(
      from(
        f in Feed,
        where: f.user_id == ^user_id and f.id == ^feed_id
      )
    )
  end
end
