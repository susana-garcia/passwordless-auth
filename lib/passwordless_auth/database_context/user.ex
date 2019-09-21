defmodule PasswordlessAuth.DatabaseContext.User do
  @moduledoc """
  User schema
  """
  use PasswordlessAuth, :model

  @type t :: %__MODULE__{
    id: String.t(),
    email: String.t(),
    name: String.t(),
    inserted_at: NaiveDateTime.t(),
    updated_at: NaiveDateTime.t()
  }

  schema "users" do
    field :email, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email])
    |> validate_required([:email])
    |> validate_email(:email)
    |> downcase_email()
    |> unique_constraint(:email)
    |> add_name()
  end

  defp validate_email(changeset, field) do
    validate_change(changeset, field, fn ^field, email ->
      cond do
        is_nil(email) ->
          []

        EmailChecker.valid?(email) ->
          []

        true ->
          [{field, "Invalid Email"}]
      end
    end)
  end

  defp downcase_email(changeset) do
    changeset
    |> get_change(:email, nil)
    |> case do
      nil ->
        changeset

      email ->
        put_change(changeset, :email, String.downcase(email))
    end
  end

  defp add_name(changeset) do
    changeset
    |> get_change(:email, nil)
    |> case do
      nil ->
        changeset

      email ->
        name =
          email
          |> String.split("@")
          |> List.first()

        put_change(changeset, :name, name)
    end
  end
end
