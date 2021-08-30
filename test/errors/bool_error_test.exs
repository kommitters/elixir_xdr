defmodule XDR.BoolErrorTest do
  use ExUnit.Case

  alias XDR.BoolError

  test "When receives :not_boolean" do
    assert_raise BoolError, "The value which you try to encode is not a boolean", fn ->
      raise BoolError, :not_boolean
    end
  end

  test "When receives :invalid_value" do
    assert_raise BoolError,
                 "The value which you try to decode must be <<0, 0, 0, 0>> or <<0, 0, 0, 1>>",
                 fn ->
                   raise BoolError, :invalid_value
                 end
  end
end
