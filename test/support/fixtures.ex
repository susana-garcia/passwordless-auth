defmodule PasswordlessAuth.Fixtures do
  @moduledoc """
  Provide Fixtures for all Tests
  """

  alias PasswordlessAuth.DatabaseContext.UserAuthContext
  alias PasswordlessAuth.DatabaseContext.UserContext

  @valid_attrs %{email: "some_email@test.com"}

  def user_fixture(attrs \\ @valid_attrs) do
    {:ok, user} =
      attrs
      |> Enum.into(@valid_attrs)
      |> UserContext.create_user()

    user
  end

  def user_auth_fixture(attrs \\ @valid_attrs) do
    user = user_fixture()

    {:ok, user_auth} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Enum.into(%{user_id: user.id})
      |> UserAuthContext.create_user_auth()

    user_auth
  end
end
