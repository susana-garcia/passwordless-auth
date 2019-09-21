defmodule PasswordlessAuth.DatabaseContext.UserAuthContext do
  @moduledoc """
  The User Auth context.
  """

  import Ecto.Query, warn: false
  alias PasswordlessAuth.Repo

  alias PasswordlessAuth.DatabaseContext.UserAuth

  @doc """
  Returns the list of user_auth.

  ## Examples

      iex> list_user_auth()
      [%UserAuth{}, ...]

  """
  def list_user_auth do
    Repo.all(UserAuth)
  end

  @doc """
  Gets a single user_auth.

  Raises `Ecto.NoResultsError` if the User auth does not exist.

  ## Examples

      iex> get_user_auth!(123)
      %UserAuth{}

      iex> get_user_auth!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_auth!(id), do: Repo.get!(UserAuth, id)

  @doc """
  Creates a user_auth.

  ## Examples

      iex> create_user_auth(%{field: value})
      {:ok, %UserAuth{}}

      iex> create_user_auth(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_auth(attrs \\ %{}) do
    %UserAuth{}
    |> UserAuth.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_auth.

  ## Examples

      iex> update_user_auth(user_auth, %{field: new_value})
      {:ok, %UserAuth{}}

      iex> update_user_auth(user_auth, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_auth(%UserAuth{} = user_auth, attrs) do
    user_auth
    |> UserAuth.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a UserAuth.

  ## Examples

      iex> delete_user_auth(user_auth)
      {:ok, %UserAuth{}}

      iex> delete_user_auth(user_auth)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_auth(%UserAuth{} = user_auth) do
    Repo.delete(user_auth)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_auth changes.

  ## Examples

      iex> change_user_auth(user_auth)
      %Ecto.Changeset{source: %UserAuth{}}

  """
  def change_user_auth(%UserAuth{} = user_auth) do
    UserAuth.changeset(user_auth, %{})
  end
end
