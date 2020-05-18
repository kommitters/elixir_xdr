defmodule Error.EnumTest do
  use ExUnit.Case

  alias XDR.Error.Enum

  test "When receives :not_list" do
    assert_raise Enum, "The declaration inside the Enum structure isn't a list", fn ->
      raise Enum, :not_list
    end
  end

  test "When receives :not_an_atom" do
    assert_raise Enum,
                 "The name of the key which you try to encode isn't an atom",
                 fn ->
                   raise Enum, :not_an_atom
                 end
  end

  test "When receives :not_binary" do
    assert_raise Enum,
                 "The value which you try to decode must be a binary value, for example: <<0, 0, 0, 2>>",
                 fn ->
                   raise Enum, :not_binary
                 end
  end

  test "When receives :invalid_key" do
    assert_raise Enum,
                 "The key which you try to encode doesn't belong to the current declarations",
                 fn ->
                   raise Enum, :invalid_key
                 end
  end
end
