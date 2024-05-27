defmodule Sonar.Repo do
  use Ecto.Repo,
    otp_app: :sonar,
    adapter: Ecto.Adapters.Postgres
end
