defmodule PasswordlessAuthWeb.Schema.Mutation.ConfirmAuthTest do
  @moduledoc false

  use PasswordlessAuth.DataCase

  @confirm_auth """
  mutation ConfirmAuth($input: ConfirmAuthInput!) {
    confirmAuth(input: $input) {
      authToken
      user {
        email
      }
    }
  }
  """

  test "verify user token successfully" do
    email = "test@test.com"
    user = user_fixture(%{email: email})
    user_auth = user_auth_fixture(%{user_id: user.id})

    assert result =
             Absinthe.run!(
               @confirm_auth,
               PasswordlessAuthWeb.Schema,
               variables: %{
                 "input" => %{
                   "email" => email,
                   "token" => user_auth.id
                 }
               }
             )

    assert %{
             data: %{
               "confirmAuth" => %{
                 "authToken" => _auth_token,
                 "user" => %{
                   "email" => ^email
                 }
               }
             }
           } = result
  end

  test "should fail when user auth is not valid" do
    assert result =
             Absinthe.run!(
               @confirm_auth,
               PasswordlessAuthWeb.Schema,
               variables: %{
                 "input" => %{
                   "email" => "random_email@test.com",
                   "token" => "5dcccaa1-9de9-4a7f-8b03-53fca7f69e71"
                 }
               }
             )

    assert %{
             data: %{"confirmAuth" => nil},
             errors: [
               %{
                 locations: [%{column: 0, line: 2}],
                 message: "verification_failed",
                 path: ["confirmAuth"]
               }
             ]
           } = result
  end
end
