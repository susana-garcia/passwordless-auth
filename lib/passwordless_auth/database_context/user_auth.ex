defmodule PasswordlessAuth.DatabaseContext.UserAuth do
  @moduledoc """
  User Auth schema
  """
  use PasswordlessAuth, :model

  alias PasswordlessAuth.DatabaseContext.User

  @type t :: %__MODULE__{
    id: String.t(),
    payload: map(),
    user: User.t(),
    inserted_at: NaiveDateTime.t(),
    updated_at: NaiveDateTime.t()
  }

  schema "user_auths" do
    field :payload, :map
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(user_auth, attrs) do
    user_auth
    |> cast(attrs, [:user_id, :payload])
    |> validate_required([:user_id])
    |> unique_constraint(:user_id)
  end

  def verify_token(queryable \\ __MODULE__, token, email) do
    valid_date =
      NaiveDateTime.add(NaiveDateTime.utc_now(), -max_age_auth_token_in_seconds(), :second)

    from(
      q in queryable,
      join: u in User,
      on: u.id == q.user_id,
      where: q.id == ^token and ilike(u.email, ^email) and q.inserted_at >= ^valid_date
    )
  end

  defp max_age_auth_token_in_seconds,
  do:
    :passwordless_auth
    |> Application.fetch_env!(:max_age_auth_token_in_seconds)
end
