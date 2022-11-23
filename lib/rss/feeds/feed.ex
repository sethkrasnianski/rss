defmodule Rss.Feeds.Feed do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rss.Accounts.User

  schema "feeds" do
    field :description, :string
    field :feed_url, :string
    field :icon_url, :string
    field :title, :string

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(feed, attrs) do
    feed
    |> cast(attrs, [:title, :description, :feed_url, :icon_url, :user_id])
    |> validate_required([:title, :description, :feed_url, :icon_url, :user_id])
    |> assoc_constraint(:user)
  end
end
