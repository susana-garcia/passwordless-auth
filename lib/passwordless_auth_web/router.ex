defmodule PasswordlessAuthWeb.Router do
  use PasswordlessAuthWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  if Mix.env() == :dev do
    scope "/dev" do
      forward "/mailbox", Plug.Swoosh.MailboxPreview, base_path: "/dev/mailbox"
    end

    forward(
      "/graphiql",
      Absinthe.Plug.GraphiQL,
      schema: PasswordlessAuthWeb.Schema,
      socket: PasswordlessAuth.UserSocket,
      pipeline: {ApolloTracing.Pipeline, :plug},
      interface: :playground,
      init_opts: [json_codec: Jason]
    )
  end

  scope "/" do
    pipe_through :api

    forward(
      "/",
      Absinthe.Plug,
      schema: PasswordlessAuthWeb.Schema,
      socket: PasswordlessAuth.UserSocket,
      pipeline: {ApolloTracing.Pipeline, :plug},
      init_opts: [json_codec: Jason]
    )
  end
end
