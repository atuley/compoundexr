defmodule Compoundexr.Repo do
  use Ecto.Repo,
    otp_app: :compoundexr,
    adapter: Ecto.Adapters.Postgres
end
