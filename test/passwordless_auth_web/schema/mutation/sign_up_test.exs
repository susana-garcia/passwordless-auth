defmodule PasswordlessAuthWeb.Schema.Mutation.SignUpTest do
  @moduledoc false

  use PasswordlessAuth.DataCase

  @sign_up """
  mutation SignUp($email: String!) {
    signUp(email: $email) {
      email
    }
  }
  """

  test "create user successfully when sign up" do
    assert result =
             Absinthe.run!(
               @sign_up,
               PasswordlessAuthWeb.Schema,
               variables: %{
                 "email" => "test@test.com"
               }
             )

    assert %{data: %{"signUp" => %{"email" => "test@test.com"}}} = result
  end

  test "should fail when user already exist" do
    email = "test@test.com"
    _user = user_fixture(%{email: email})

    assert result =
             Absinthe.run!(
               @sign_up,
               PasswordlessAuthWeb.Schema,
               variables: %{
                 "email" => email
               }
             )

    assert %{
             data: %{"signUp" => nil},
             errors: [
               %{
                 message: "already_exist",
               }
             ]
           } = result
  end

  test "should fail when email is not valid" do
    assert result =
             Absinthe.run!(
               @sign_up,
               PasswordlessAuthWeb.Schema,
               variables: %{
                 "email" => "blabliblu"
               }
             )

    assert %{
             data: %{"signUp" => nil},
             errors: [
               %{
                 message: "server_error",
               }
             ]
           } = result
  end
end
