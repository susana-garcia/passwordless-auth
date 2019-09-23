defmodule PasswordlessAuthWeb.Schema.Query.UpdateCurrentUserTest do
  @moduledoc false

  use PasswordlessAuth.DataCase, async: false

  @update_current_user """
  mutation UpdateUser($input: Input!) {
    updateUser(input: $input) {
      name
    }
  }
  """

  test "update current signed in user successfully" do
    email = "test@gmail.com"
    user = user_fixture(%{email: email})

    new_name = "teilist-user-name"

    assert result =
             Absinthe.run!(
               @update_current_user,
               PasswordlessAuthWeb.Schema,
               variables: %{
                 "input" => %{
                   "name" => new_name
                 }
               },
               context: %{
                 current_user: user
               }
             )

    assert %{
             data: %{
               "updateUser" => %{
                 "name" => ^new_name
               }
             }
           } = result
  end

  test "should fail when trying to update not auth user" do
    assert result =
             Absinthe.run!(
               @update_current_user,
               PasswordlessAuthWeb.Schema,
               variables: %{
                 "input" => %{
                   "name" => "New name"
                 }
               }
             )

    assert %{
             data: %{"updateUser" => nil},
             errors: [
               %{
                 message: "unauthorize"
               }
             ]
           } = result
  end
end
