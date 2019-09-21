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
end
