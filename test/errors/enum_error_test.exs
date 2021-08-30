defmodule XDR.EnumErrorTest do
  use ExUnit.Case

  alias XDR.EnumError

  test "When receives :not_list" do
    assert_raise EnumError, "The declaration inside the Enum structure isn't a list", fn ->
      raise EnumError, :not_list
    end
  end

  test "When receives :not_an_atom" do
    assert_raise EnumError,
                 "The name of the key which you try to encode isn't an atom",
                 fn ->
                   raise EnumError, :not_an_atom
                 end
  end

  test "When receives :not_binary" do
    assert_raise EnumError,
                 "The value which you try to decode must be a binary value, for example: <<0, 0, 0, 2>>",
                 fn ->
                   raise EnumError, :not_binary
                 end
  end

  test "When receives :invalid_key" do
    assert_raise EnumError,
                 "The key which you try to encode doesn't belong to the current declarations",
                 fn ->
                   raise EnumError, :invalid_key
                 end
  end
end
