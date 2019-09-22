defmodule PasswordlessAuth.DatabaseContext.User do
  @moduledoc """
  User schema
  """
  use PasswordlessAuth, :model

  alias PasswordlessAuth.DatabaseContext.UserAuth

  @type t :: %__MODULE__{
    id: String.t(),
    email: String.t(),
    name: String.t(),
    user_auth: UserAuth.t() | nil,
    inserted_at: NaiveDateTime.t(),
    updated_at: NaiveDateTime.t()
  }

  schema "users" do
    field :email, :string
    field :name, :string

    has_one :user_auth, UserAuth, on_delete: :delete_all

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

  def get_by_email(queryable \\ __MODULE__, email) do
    from(
      q in queryable,
      where: ilike(q.email, ^email),
      limit: 1
    )
  end
end
