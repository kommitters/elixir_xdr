defmodule XDR.VoidErrorTest do
  use ExUnit.Case

  alias XDR.VoidError

  test "When receives :not_binary" do
    assert_raise VoidError,
                 "The value which you try to decode must be a binary value, for example: <<0, 0, 0, 5>>",
                 fn ->
                   raise VoidError, :not_binary
                 end
  end

  test "When receives :not_void" do
    assert_raise VoidError,
                 "The value which you try to encode is not void",
                 fn ->
                   raise VoidError, :not_void
                 end
  end
end
