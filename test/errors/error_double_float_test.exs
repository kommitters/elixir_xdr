defmodule Error.DoubleFloatTest do
  use ExUnit.Case

  alias XDR.Error.DoubleFloat

  test "When receives :not_number" do
    assert_raise DoubleFloat,
                 "The value which you try to encode is not an integer or float value",
                 fn ->
                   raise DoubleFloat, :not_number
                 end
  end

  test "When receives :not_binary" do
    assert_raise DoubleFloat,
                 "The value which you try to decode must be a binary value, for example: <<0, 0, 0, 0, 0, 0, 0, 5>>",
                 fn ->
                   raise DoubleFloat, :not_binary
                 end
  end
end
