defmodule Rss.Repo do
  use Ecto.Repo,
    otp_app: :rss,
    adapter: Ecto.Adapters.Postgres
end
