defmodule PasswordlessAuthWeb.Schema do
  @moduledoc """
  Schema of Passwordless Auth API
  """

  use Absinthe.Schema
  use Absinthe.Ecto, repo: PasswordlessAuth.Repo
  use ApolloTracing

  alias PasswordlessAuthWeb.Schema.Resolvers.AuthResolver
  alias PasswordlessAuthWeb.Schema.Resolvers.UserResolver

  import_types(__MODULE__.Scalar.UUID)

  @desc """
  OK Result (is always nil)
  """
  enum :ok do
    value(:ok)
  end

  query do
    field :example, :ok do
      {:ok, nil}
    end
  end

  @desc """
  Sign up object
  """
  object :request_auth do
    field(:email, non_null(:string))
  end

  @desc """
  User object
  """
  object :user do
    field(:email, non_null(:string))
    field(:name, non_null(:string))
    field(:id, non_null(:uuid))
  end

  @desc """
  Confim auth object
  """
  object :confirm_auth do
    field(:auth_token, non_null(:string))
    field(:user, non_null(:user))
  end

  @desc """
  Confirm auth input object
  """
  input_object :confirm_auth_input do
    field(:email, non_null(:string))
    field(:token, non_null(:string))
  end

  @desc """
  User input object
  """
  input_object :input do
    field(:name, :string)
  end

  mutation do
    @desc """
    Sign up
    """
    field :sign_up, :request_auth do
      arg(:email, non_null(:string))

      resolve(&AuthResolver.sign_up/3)
    end

    @desc """
    Login
    """
    field :login, :request_auth do
      arg(:email, non_null(:string))

      resolve(&AuthResolver.login/3)
    end

    @desc """
    Confim auth
    """
    field :confirm_auth, :confirm_auth do
      arg(:input, non_null(:confirm_auth_input))

      resolve(&AuthResolver.confim/3)
    end

    @desc """
    Update user (only for sign in users)
    """
    field :update_user, :user do
      arg(:input, non_null(:input))

      resolve(&UserResolver.update_user/3)
    end
  end
end
