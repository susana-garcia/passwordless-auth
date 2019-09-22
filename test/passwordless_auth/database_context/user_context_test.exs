defmodule PasswordlessAuth.DatabaseContext.UserContextTest do
  @moduledoc false
  use PasswordlessAuth.DataCase

  alias PasswordlessAuth.DatabaseContext.UserContext

  describe "user" do
    alias PasswordlessAuth.DatabaseContext.User

    @valid_attrs %{email: "some_email@test.com"}
    @update_attrs %{email: "some_updated_email@test.com"}
    @invalid_attrs %{email: nil}

    test "list_user/0 returns all user" do
      user = user_fixture()
      assert UserContext.list_user() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert UserContext.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = UserContext.create_user(@valid_attrs)
      assert user.email == "some_email@test.com"
      assert user.name == "some_email"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserContext.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = UserContext.update_user(user, @update_attrs)
      assert user.email == "some_updated_email@test.com"
      assert user.name == "some_updated_email"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = UserContext.update_user(user, @invalid_attrs)
      assert user == UserContext.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = UserContext.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> UserContext.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = UserContext.change_user(user)
    end
  end
end
