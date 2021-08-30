defmodule XDR.UnionErrorTest do
  use ExUnit.Case

  alias XDR.UnionError

  test "When receives :not_list" do
    assert_raise UnionError,
                 "The :declarations received by parameter must be a keyword list which belongs to an XDR.Enum",
                 fn ->
                   raise UnionError, :not_list
                 end
  end

  test "When receives :not_binary" do
    assert_raise UnionError,
                 "The :identifier received by parameter must be a binary value, for example: <<0, 0, 0, 5>>",
                 fn ->
                   raise UnionError, :not_binary
                 end
  end

  test "When receives :not_number" do
    assert_raise UnionError,
                 "The value which you try to decode is not an integer value",
                 fn ->
                   raise UnionError, :not_number
                 end
  end

  test "When receives :not_atom" do
    assert_raise UnionError,
                 "The :identifier which you try to decode from the Enum Union is not an atom",
                 fn ->
                   raise UnionError, :not_atom
                 end
  end
end
