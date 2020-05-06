defmodule Error.FixedArrayTest do
  use ExUnit.Case

  alias XDR.Error.FixedArray

  test "When receives :invalid_length" do
    assert_raise FixedArray, "the length of the array and the length must be the same", fn ->
      raise FixedArray, :invalid_length
    end
  end

  test "When receives :not_list" do
    assert_raise FixedArray,
                 "the value which you try to encode must be a list",
                 fn ->
                   raise FixedArray, :not_list
                 end
  end

  test "When receives :not_number" do
    assert_raise FixedArray,
                 "the length received by parameter must be an integer",
                 fn ->
                   raise FixedArray, :not_number
                 end
  end

  test "When receives :not_binary" do
    assert_raise FixedArray,
                 "the value which you try to decode must be a binary value",
                 fn ->
                   raise FixedArray, :not_binary
                 end
  end

  test "When receives :not_valid_binary" do
    assert_raise FixedArray,
                 "the value which you try to decode must have a multiple of 4 byte-size",
                 fn ->
                   raise FixedArray, :not_valid_binary
                 end
  end
end
