defmodule Fitness.Repo do
  use Ecto.Repo,
    otp_app: :fitness,
    adapter: Ecto.Adapters.Postgres
end
