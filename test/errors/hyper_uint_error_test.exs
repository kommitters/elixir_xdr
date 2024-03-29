defmodule XDR.HyperUIntErrorTest do
  use ExUnit.Case

  alias XDR.HyperUIntError

  test "When receives :not_integer" do
    assert_raise HyperUIntError, "The value which you try to encode is not an integer", fn ->
      raise HyperUIntError, :not_integer
    end
  end

  test "When receives :not_binary" do
    assert_raise HyperUIntError,
                 "The value which you try to decode must be a binary value, for example: <<0, 0, 0, 0, 0, 0, 0, 5>>",
                 fn ->
                   raise HyperUIntError, :not_binary
                 end
  end

  test "When receives :exceed_upper_limit" do
    assert_raise HyperUIntError,
                 "The integer which you try to encode exceed the upper limit of an Hyper Unsigned Integer, the value must be less than 18_446_744_073_709_551_615",
                 fn ->
                   raise HyperUIntError, :exceed_upper_limit
                 end
  end

  test "When receives :exceed_lower_limit" do
    assert_raise HyperUIntError,
                 "The integer which you try to encode exceed the lower limit of an Hyper Unsigned Integer, the value must be more than 0",
                 fn ->
                   raise HyperUIntError, :exceed_lower_limit
                 end
  end
end
