defmodule XDR.FloatErrorTest do
  use ExUnit.Case

  alias XDR.FloatError

  test "When receives :not_number" do
    assert_raise FloatError,
                 "The value which you try to encode is not an integer or float value",
                 fn ->
                   raise FloatError, :not_number
                 end
  end

  test "When receives :not_binary" do
    assert_raise FloatError,
                 "The value which you try to decode must be a binary value, for example: <<0, 0, 0, 2>>",
                 fn ->
                   raise FloatError, :not_binary
                 end
  end
end
