defmodule PasswordlessAuth.Repo.Migrations.AddInitialTables do
  @moduledoc false
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string

      timestamps()
    end

    create unique_index(:users, [:email])

    create table(:user_auths) do
      add(:payload, :jsonb)

      add(
        :user_id,
        references(:users, type: :binary_id, on_delete: :delete_all),
        null: false
      )

      timestamps(autogenerate: true, size: 6)
    end

    create unique_index(:user_auths, [:user_id])
  end
end
