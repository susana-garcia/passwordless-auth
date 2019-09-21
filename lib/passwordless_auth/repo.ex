defmodule PasswordlessAuth.Repo do
  use Ecto.Repo,
    otp_app: :passwordless_auth,
    adapter: Ecto.Adapters.Postgres
end
