defmodule PasswordlessAuthWeb.Schema.Scalar.UUIDTest do
  @moduledoc false

  use ExUnit.Case

  alias PasswordlessAuthWeb.Schema.Scalar.UUID, as: UUIDScalar

  doctest UUIDScalar

  defmodule TestSchema do
    @moduledoc false

    use Absinthe.Schema

    import_types(UUIDScalar)

    query do
      field :test, :uuid do
        resolve(fn _, _ ->
          Ecto.UUID.cast("fa005a36-d9d4-4689-acca-cac8d8317090")
        end)
      end
    end

    mutation do
      field :test, :uuid do
        arg(:test, :uuid)

        resolve(fn %{test: test}, _ ->
          {:ok, test}
        end)
      end
    end
  end

  describe "schema" do
    test "contains scalar" do
      assert %{name: "Uuid"} = UUIDScalar.__absinthe_type__(:uuid)
    end
  end

  describe "serialize" do
    test "works" do
      assert {:ok, %{data: %{"test" => "fa005a36-d9d4-4689-acca-cac8d8317090"}}} =
               Absinthe.run("{ test }", TestSchema)
    end
  end

  describe "parse" do
    test "works with valid string" do
      assert {:ok, %{data: %{"test" => "fa005a36-d9d4-4689-acca-cac8d8317090"}}} =
               Absinthe.run(
                 """
                 mutation {
                   test(test: "fa005a36-d9d4-4689-acca-cac8d8317090")
                 }
                 """,
                 TestSchema
               )
    end

    test "errors with invalid string" do
      assert {:ok,
              %{
                errors: [
                  %{
                    message: "Argument \"test\" has invalid value \"a36-d9d4-4689-acca-cac8d\"."
                  }
                ]
              }} =
               Absinthe.run(
                 """
                 mutation {
                   test(test: "a36-d9d4-4689-acca-cac8d")
                 }
                 """,
                 TestSchema
               )
    end
  end
end
