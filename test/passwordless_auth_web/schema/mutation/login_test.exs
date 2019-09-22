defmodule PasswordlessAuthWeb.Schema.Mutation.LoginTest do
  @moduledoc false

  use PasswordlessAuth.DataCase

  @sign_up """
  mutation SignUp($email: String!) {
    signUp(email: $email) {
      email
    }
  }
  """

  @login """
  mutation Login($email: String!) {
    login(email: $email) {
      email
    }
  }
  """

  test "create user successfully when login" do
    assert result =
             Absinthe.run!(
               @sign_up,
               PasswordlessAuthWeb.Schema,
               variables: %{
                 "email" => "test@test.com"
               }
             )

    assert %{data: %{"signUp" => %{"email" => "test@test.com"}}} = result

    assert result =
             Absinthe.run!(
               @login,
               PasswordlessAuthWeb.Schema,
               variables: %{
                 "email" => "test@test.com"
               }
             )

    assert %{data: %{"login" => %{"email" => "test@test.com"}}} = result
  end

  test "should upsert user auth successfully when calling login twice" do
    assert result =
             Absinthe.run!(
               @sign_up,
               PasswordlessAuthWeb.Schema,
               variables: %{
                 "email" => "test@test.com"
               }
             )

    assert %{data: %{"signUp" => %{"email" => "test@test.com"}}} = result

    assert result =
             Absinthe.run!(
               @login,
               PasswordlessAuthWeb.Schema,
               variables: %{
                 "email" => "test@test.com"
               }
             )

    assert %{data: %{"login" => %{"email" => "test@test.com"}}} = result

    assert result =
             Absinthe.run!(
               @login,
               PasswordlessAuthWeb.Schema,
               variables: %{
                 "email" => "test@test.com"
               }
             )

    assert %{data: %{"login" => %{"email" => "test@test.com"}}} = result
  end

  test "should fail when email is not valid" do
    assert result =
             Absinthe.run!(
               @login,
               PasswordlessAuthWeb.Schema,
               variables: %{
                 "email" => "blabliblu"
               }
             )

    assert %{
             data: %{"login" => nil},
             errors: [
               %{
                 locations: [%{column: 0, line: 2}],
                 message: "not_found",
                 path: ["login"]
               }
             ]
           } = result
  end
end
