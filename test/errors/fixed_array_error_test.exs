defmodule XDR.FixedArrayErrorTest do
  use ExUnit.Case

  alias XDR.FixedArrayError

  test "When receives :invalid_length" do
    assert_raise FixedArrayError, "the length of the array and the length must be the same", fn ->
      raise FixedArrayError, :invalid_length
    end
  end

  test "When receives :not_list" do
    assert_raise FixedArrayError,
                 "the value which you try to encode must be a list",
                 fn ->
                   raise FixedArrayError, :not_list
                 end
  end

  test "When receives :not_number" do
    assert_raise FixedArrayError,
                 "the length received by parameter must be an integer",
                 fn ->
                   raise FixedArrayError, :not_number
                 end
  end

  test "When receives :not_binary" do
    assert_raise FixedArrayError,
                 "the value which you try to decode must be a binary value",
                 fn ->
                   raise FixedArrayError, :not_binary
                 end
  end

  test "When receives :not_valid_binary" do
    assert_raise FixedArrayError,
                 "the value which you try to decode must have a multiple of 4 byte-size",
                 fn ->
                   raise FixedArrayError, :not_valid_binary
                 end
  end

  test "When receives :invalid_type" do
    assert_raise FixedArrayError,
                 "the type must be a module",
                 fn ->
                   raise FixedArrayError, :invalid_type
                 end
  end
end
