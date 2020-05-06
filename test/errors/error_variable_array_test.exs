defmodule Error.VariableArrayTest do
  use ExUnit.Case

  alias XDR.Error.VariableArray

  test "When receives :not_list" do
    assert_raise VariableArray, "the value which you try to encode must be a list", fn ->
      raise VariableArray, :not_list
    end
  end

  test "When receives :not_number" do
    assert_raise VariableArray,
                 "the max length must be an integer value",
                 fn ->
                   raise VariableArray, :not_number
                 end
  end

  test "When receives :not_binary" do
    assert_raise VariableArray,
                 "The value which you pass through parameters must be a binary value, for example: <<0, 0, 0, 5>>",
                 fn ->
                   raise VariableArray, :not_binary
                 end
  end

  test "When receives :exceed_lower_bound" do
    assert_raise VariableArray,
                 "The minimum value of the length of the variable is 0",
                 fn ->
                   raise VariableArray, :exceed_lower_bound
                 end
  end

  test "When receives :exceed_upper_bound" do
    assert_raise VariableArray,
                 "The maximum value of the length of the variable is 4_294_967_295",
                 fn ->
                   raise VariableArray, :exceed_upper_bound
                 end
  end

  test "When receives :length_over_max" do
    assert_raise VariableArray,
                 "The number which represents the length from decode the opaque as UInt is bigger than the defined max",
                 fn ->
                   raise VariableArray, :length_over_max
                 end
  end
end
