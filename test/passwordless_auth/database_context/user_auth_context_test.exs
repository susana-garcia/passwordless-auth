defmodule PasswordlessAuth.DatabaseContext.UserAuthContextTest do
  @moduledoc false
  use PasswordlessAuth.DataCase

  alias PasswordlessAuth.DatabaseContext.UserAuthContext

  describe "user_auth" do
    alias PasswordlessAuth.DatabaseContext.UserAuth

    @valid_attrs %{payload: %{}}
    @update_attrs %{payload: %{}}
    @invalid_attrs %{user_id: nil}

    test "list_user_auth/0 returns all user_auth" do
      user_auth = user_auth_fixture()
      assert UserAuthContext.list_user_auth() == [user_auth]
    end

    test "get_user_auth!/1 returns the user_auth with given id" do
      user_auth = user_auth_fixture()
      assert UserAuthContext.get_user_auth!(user_auth.id) == user_auth
    end

    test "create_user_auth/1 with valid data creates a user_auth" do
      user = user_fixture()

      assert {:ok, %UserAuth{} = user_auth} =
      @valid_attrs
      |> Enum.into(%{user_id: user.id})
      |> UserAuthContext.create_user_auth()
      assert user_auth.payload == %{}
    end

    test "create_user_auth/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserAuthContext.create_user_auth(@invalid_attrs)
    end

    test "update_user_auth/2 with valid data updates the user_auth" do
      user_auth = user_auth_fixture()
      assert {:ok, %UserAuth{} = user_auth} = UserAuthContext.update_user_auth(user_auth, @update_attrs)
      assert user_auth.payload == %{}
    end

    test "update_user_auth/2 with invalid data returns error changeset" do
      user_auth = user_auth_fixture()
      assert {:error, %Ecto.Changeset{}} = UserAuthContext.update_user_auth(user_auth, @invalid_attrs)
      assert user_auth == UserAuthContext.get_user_auth!(user_auth.id)
    end

    test "delete_user_auth/1 deletes the user_auth" do
      user_auth = user_auth_fixture()
      assert {:ok, %UserAuth{}} = UserAuthContext.delete_user_auth(user_auth)
      assert_raise Ecto.NoResultsError, fn -> UserAuthContext.get_user_auth!(user_auth.id) end
    end

    test "change_user_auth/1 returns a user_auth changeset" do
      user_auth = user_auth_fixture()
      assert %Ecto.Changeset{} = UserAuthContext.change_user_auth(user_auth)
    end
  end
end
