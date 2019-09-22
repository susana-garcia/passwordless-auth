defmodule PasswordlessAuthWeb.Schema.Scalar.UUID do
  @moduledoc """
  UUID Type
  """

  use Absinthe.Schema.Notation

  alias Absinthe.Blueprint.Input

  @desc """
  UUID Generic Type
  Example: `14c6f043-bbbc-4eb9-82d3-66f8ea162b9c`
  """
  scalar :uuid do
    parse(&_parse/1)
    serialize(&_serialize/1)
  end

  @spec _serialize(uuid :: binary()) :: binary()
  defp _serialize(uuid), do: uuid

  @spec _parse(input :: any) :: {:ok, String.t() | nil} | :error
  defp _parse(%Input.Null{}) do
    {:ok, nil}
  end

  defp _parse(%Input.String{value: value}) do
    Ecto.UUID.cast(value)
  end

  defp _parse(_other), do: :error
end
