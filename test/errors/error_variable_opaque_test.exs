defmodule Error.VariableOpaqueTest do
  use ExUnit.Case

  alias XDR.Error.VariableOpaque

  test "When receives :not_number" do
    assert_raise VariableOpaque,
                 "The value which you pass through parameters is not an integer",
                 fn ->
                   raise VariableOpaque, :not_number
                 end
  end

  test "When receives :not_binary" do
    assert_raise VariableOpaque,
                 "The value which you pass through parameters must be a binary value, for example: <<0, 0, 0, 5>>",
                 fn ->
                   raise VariableOpaque, :not_binary
                 end
  end

  test "When receives :exceed_lower_bound" do
    assert_raise VariableOpaque,
                 "The minimum value of the length of the variable is 0",
                 fn ->
                   raise VariableOpaque, :exceed_lower_bound
                 end
  end

  test "When receives :exceed_upper_bound" do
    assert_raise VariableOpaque,
                 "The maximum value of the length of the variable is 4_294_967_295",
                 fn ->
                   raise VariableOpaque, :exceed_upper_bound
                 end
  end

  test "When receives :length_over_max" do
    assert_raise VariableOpaque,
                 "The number which represents the length from decode the opaque as UInt is bigger than the defined max (max by default is 4_294_967_295)",
                 fn ->
                   raise VariableOpaque, :length_over_max
                 end
  end

  test "When receives :length_over_rest" do
    assert_raise VariableOpaque,
                 "The XDR has an invalid length, it must be less than byte-size of the rest",
                 fn ->
                   raise VariableOpaque, :length_over_rest
                 end
  end

  test "when receives :invalid_length" do
    assert_raise VariableOpaque,
                 "The max length that is passed through parameters must be biger to the byte size of the XDR",
                 fn ->
                   raise VariableOpaque, :invalid_length
                 end
  end
end
