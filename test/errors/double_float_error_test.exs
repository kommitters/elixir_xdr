defmodule XDR.DoubleFloatErrorTest do
  use ExUnit.Case

  alias XDR.DoubleFloatError

  test "When receives :not_number" do
    assert_raise DoubleFloatError,
                 "The value which you try to encode is not an integer or float value",
                 fn ->
                   raise DoubleFloatError, :not_number
                 end
  end

  test "When receives :not_binary" do
    assert_raise DoubleFloatError,
                 "The value which you try to decode must be a binary value, for example: <<0, 0, 0, 0, 0, 0, 0, 5>>",
                 fn ->
                   raise DoubleFloatError, :not_binary
                 end
  end
end
