defmodule PasswordlessAuthWeb.Schema.Resolvers.AuthResolver do
  @moduledoc """
  Resolver for Sign Up flow
  """

  alias PasswordlessAuth.DatabaseContext.User
  alias PasswordlessAuth.DatabaseContext.UserAuth
  alias PasswordlessAuth.DatabaseContext.UserAuthContext
  alias PasswordlessAuth.DatabaseContext.UserContext
  alias PasswordlessAuthWeb.Mailer
  alias PasswordlessAuthWeb.Plug.JwtAuthToken

  require Logger

  def sign_up(_, params, _resolution) do
    case UserContext.create_user(params) do
      {:ok, user} ->
        create_user_auth_and_send_link(user, params)

      {:error,
       %Ecto.Changeset{
         errors: [
           email: {"has already been taken", [constraint: :unique, constraint_name: _]}
         ]
       }} ->
        {:error, :already_exist}

      _ ->
        {:error, :server_error}
    end
  end

  def confim(_, %{input: %{token: token, email: email}}, _resolution) do
    case UserAuthContext.verify_token(token, email) do
      %UserAuth{user: %User{} = user} = auth ->
        UserAuthContext.delete_user_auth(auth)

        {:ok, jwt_token, _claims} = JwtAuthToken.generate_and_sign(%{"user_id" => user.id})
        {:ok, %{auth_token: jwt_token, user: user}}

      _ ->
        {:error, :verification_failed}
    end
  end

  defp create_user_auth_and_send_link(user, params) do
    {:ok, auth} =
      UserAuthContext.upsert_user_auth(%{
        user_id: user.id,
        payload: params
      })

    send_magic_link(params, auth, user)
    {:ok, %{email: user.email}}
  end

  defp send_magic_link(params, auth, user) do
    params = Map.put(params, :token, auth.id)

    link =
      app_ui_url()
      |> URI.parse()
      |> URI.merge("/auth/confirm")
      |> Map.put(:query, URI.encode_query(params))
      |> URI.to_string()

    %{
      user: user,
      link: link
    }
    |> Mailer.login()
    |> Mailer.deliver()

    Logger.warn(link)
  end

  defp app_ui_url, do: Application.fetch_env!(:passwordless_auth, :app_ui_url)
end
