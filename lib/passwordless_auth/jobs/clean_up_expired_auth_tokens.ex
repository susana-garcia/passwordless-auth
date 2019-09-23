defmodule PasswordlessAuth.Jobs.CleanUpExpiredAuthTokens do
  @moduledoc """
  Clean up expired tokens from database that has not been used.
  """

  alias PasswordlessAuth.DatabaseContext.UserAuth
  alias PasswordlessAuth.Repo

  require Logger

  def delete do
    Logger.info("Deleting old tokens...")

    {num_entries, _} = Repo.delete_all(UserAuth.get_old_tokens())

    Logger.info("Deleted #{num_entries} old tokens.")

    :ok
  end
end
