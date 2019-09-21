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
  end
end
