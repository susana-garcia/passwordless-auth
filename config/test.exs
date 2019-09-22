use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :passwordless_auth, PasswordlessAuthWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :passwordless_auth, PasswordlessAuth.Repo,
  username: "postgres",
  password: "postgres",
  database: "passwordless_auth_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :joken,
  default_signer: "Mflr/inJj5YSnK5s1QH7L8RcUIY7SRxI0XpRxZsugl6XluLT6hldOgX6Vu0u3C8i"

config :passwordless_auth, PasswordlessAuthWeb.Mailer,
  # adapter: Swoosh.Adapters.Mailgun,
  adapter: Swoosh.Adapters.Local,
  domain: "sandbox-your-domain.mailgun.org",
  api_key: "your-key",
  from_address: {"passwordless_auth", "hello@passwordless-auth.com"}
