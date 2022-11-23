defmodule Rss.Repo.Migrations.CreateFeeds do
  use Ecto.Migration

  def change do
    create table(:feeds) do
      add :title, :string
      add :description, :string
      add :feed_url, :string
      add :icon_url, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:feeds, [:user_id])
  end
end
