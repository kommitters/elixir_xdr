defmodule XDR.VariableArrayErrorTest do
  use ExUnit.Case

  alias XDR.VariableArrayError

  test "When receives :not_list" do
    assert_raise VariableArrayError, "the value which you try to encode must be a list", fn ->
      raise VariableArrayError, :not_list
    end
  end

  test "When receives :not_number" do
    assert_raise VariableArrayError,
                 "the max length must be an integer value",
                 fn ->
                   raise VariableArrayError, :not_number
                 end
  end

  test "When receives :not_binary" do
    assert_raise VariableArrayError,
                 "The value which you pass through parameters must be a binary value, for example: <<0, 0, 0, 5>>",
                 fn ->
                   raise VariableArrayError, :not_binary
                 end
  end

  test "When receives :exceed_lower_bound" do
    assert_raise VariableArrayError,
                 "The minimum value of the length of the variable is 1",
                 fn ->
                   raise VariableArrayError, :exceed_lower_bound
                 end
  end

  test "When receives :exceed_upper_bound" do
    assert_raise VariableArrayError,
                 "The maximum value of the length of the variable is 4_294_967_295",
                 fn ->
                   raise VariableArrayError, :exceed_upper_bound
                 end
  end

  test "When receives :length_over_max" do
    assert_raise VariableArrayError,
                 "The number which represents the length from decode the opaque as UInt is bigger than the defined max",
                 fn ->
                   raise VariableArrayError, :length_over_max
                 end
  end

  test "When receives :invalid_length" do
    assert_raise VariableArrayError,
                 "The length of the binary exceeds the max_length of the type",
                 fn ->
                   raise VariableArrayError, :invalid_length
                 end
  end

  test "When receives :invalid_binary" do
    assert_raise VariableArrayError,
                 "The data which you try to decode has an invalid number of bytes, it must be equal to or greater than the size of the array multiplied by 4",
                 fn ->
                   raise VariableArrayError, :invalid_binary
                 end
  end
end
