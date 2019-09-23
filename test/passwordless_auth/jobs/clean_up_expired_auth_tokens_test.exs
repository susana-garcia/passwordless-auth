defmodule PasswordlessAuth.Jobs.CleanUpExpiredAuthTokensTest do
  @moduledoc false
  use PasswordlessAuth.DataCase

  alias PasswordlessAuth.DatabaseContext.UserAuth
  alias PasswordlessAuth.Fixtures
  alias PasswordlessAuth.Jobs.CleanUpExpiredAuthTokens
  alias PasswordlessAuth.Repo

  describe "clean_up_old_auth_tokens" do
    test "should delete expired auth tokens from database" do
      user = Fixtures.user_fixture(%{email: "test@test.com", username: "some_username"})

      old_token_date =
        NaiveDateTime.utc_now()
        |> NaiveDateTime.add(-60 * 60 * 3, :second)
        |> NaiveDateTime.truncate(:second)

      {:ok, _auth} =
        %UserAuth{
          id: "294b3cf9-34aa-4074-b16f-44e659250337",
          user_id: user.id,
          inserted_at: old_token_date,
          updated_at: old_token_date
        }
        |> UserAuth.changeset(%{})
        |> Repo.insert()

      CleanUpExpiredAuthTokens.delete()

      auths = Repo.all(UserAuth)
      assert auths == []
    end
  end
end
