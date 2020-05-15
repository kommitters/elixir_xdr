defmodule Error.VoidTest do
  use ExUnit.Case

  alias XDR.Error.Void

  test "When receives :not_binary" do
    assert_raise Void,
                 "The value which you try to decode must be a binary value, for example: <<0, 0, 0, 5>>",
                 fn ->
                   raise Void, :not_binary
                 end
  end

  test "When receives :not_void" do
    assert_raise Void,
                 "The value which you try to encode is not void",
                 fn ->
                   raise Void, :not_void
                 end
  end
end
