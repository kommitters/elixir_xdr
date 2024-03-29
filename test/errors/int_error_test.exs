defmodule XDR.IntErrorTest do
  use ExUnit.Case

  alias XDR.IntError

  test "When receives :not_integer" do
    assert_raise IntError, "The value which you try to encode is not an integer", fn ->
      raise IntError, :not_integer
    end
  end

  test "When receives :not_binary" do
    assert_raise IntError,
                 "The value which you try to decode must be a binary value, for example: <<0, 0, 0, 2>>",
                 fn ->
                   raise IntError, :not_binary
                 end
  end

  test "When receives :exceed_upper_limit" do
    assert_raise IntError,
                 "The integer which you try to encode exceed the upper limit of an integer, the value must be less than 2_147_483_647",
                 fn ->
                   raise IntError, :exceed_upper_limit
                 end
  end

  test "When receives :exceed_lower_limit" do
    assert_raise IntError,
                 "The integer which you try to encode exceed the lower limit of an integer, the value must be more than -2_147_483_648",
                 fn ->
                   raise IntError, :exceed_lower_limit
                 end
  end
end
