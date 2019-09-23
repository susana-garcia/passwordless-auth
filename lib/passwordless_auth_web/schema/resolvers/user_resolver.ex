defmodule PasswordlessAuthWeb.Schema.Resolvers.UserResolver do
  @moduledoc """
  Resolver for User
  """

  alias Ecto.Changeset
  alias PasswordlessAuth.DatabaseContext.UserContext

  require Logger

  def update_user(_args, %{input: params}, %{context: %{current_user: current_user}}) do
    current_user
    |> UserContext.update_user(params)
    |> changeset_result()
  end

  def update_user(_args, _params, _context) do
    {:error, :unauthorize}
  end

  defp changeset_result({:ok, result}), do: {:ok, result}

  defp changeset_result({:error, %Changeset{} = changeset}),
    do: {:error, %{message: format(changeset)}}

  defp changeset_result({:error, error}), do: {:error, error}

  defp format(changeset) do
    Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
