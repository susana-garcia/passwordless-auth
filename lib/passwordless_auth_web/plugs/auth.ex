defmodule PasswordlessAuthWeb.Plug.Auth do
  @moduledoc """
  Jwt Authentication Plug
  """
  @behaviour Plug

  alias PasswordlessAuth.DatabaseContext.User
  alias PasswordlessAuth.DatabaseContext.UserContext
  alias PasswordlessAuthWeb.Plug.JwtAuthToken

  import Plug.Conn

  def init(_opts), do: nil

  def call(conn, _opts) do
    context = build_context(conn)
    put_private(conn, :absinthe, %{context: context})
  end

  @doc """
  Return the current user context based on the authorization header
  """
  def build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, current_user_id} <- verify_and_validate(token),
         %User{} = user <- UserContext.get_user(current_user_id) do
      %{current_user: user}
    else
      _ -> %{}
    end
  end

  defp verify_and_validate(token) do
    case JwtAuthToken.verify_and_validate(token) do
      {:ok, %{"user_id" => current_user_id}} ->
        {:ok, current_user_id}

      _ ->
        {:error, :unauthorize}
    end
  end
end
