defmodule Error.HyperIntTest do
  use ExUnit.Case

  alias XDR.Error.HyperInt

  test "When receives :not_integer" do
    assert_raise HyperInt, "The value which you try to encode is not an integer", fn ->
      raise HyperInt, :not_integer
    end
  end

  test "When receives :not_binary" do
    assert_raise HyperInt,
                 "The value which you try to decode must be a binary value, for example: <<0, 0, 0, 0, 0, 0, 0, 5>>",
                 fn ->
                   raise HyperInt, :not_binary
                 end
  end

  test "When receives :exceed_upper_limit" do
    assert_raise HyperInt,
                 "The integer which you try to encode exceed the upper limit of an Hyper Integer, the value must be less than 9_223_372_036_854_775_807",
                 fn ->
                   raise HyperInt, :exceed_upper_limit
                 end
  end

  test "When receives :exceed_lower_limit" do
    assert_raise HyperInt,
                 "The integer which you try to encode exceed the lower limit of an Hyper Integer, the value must be more than -9_223_372_036_854_775_808",
                 fn ->
                   raise HyperInt, :exceed_lower_limit
                 end
  end
end
