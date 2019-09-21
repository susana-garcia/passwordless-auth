defmodule PasswordlessAuthWeb.Schema do
  @moduledoc """
  Schema for Passwordless Auth API
  """

  use Absinthe.Schema
  use Absinthe.Ecto, repo: PasswordlessAuth.Repo
  use ApolloTracing

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
end
