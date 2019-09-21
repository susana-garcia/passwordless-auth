defmodule PasswordlessAuthWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :passwordless_auth

  socket "/socket", PasswordlessAuthWeb.UserSocket,
    websocket: true,
    longpoll: false

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_passwordless_auth_key",
    signing_salt: "ZTPkXnUA"

  plug(CORSPlug, origin: [:self])

  plug PasswordlessAuthWeb.Router
end
