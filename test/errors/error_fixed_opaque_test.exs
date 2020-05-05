defmodule Error.FixedOpaqueTest do
  use ExUnit.Case

  alias XDR.Error.FixedOpaque

  test "When receives :not_number" do
    assert_raise FixedOpaque,
                 "The value which you pass through parameters is not an integer",
                 fn ->
                   raise FixedOpaque, :not_number
                 end
  end

  test "When receives :not_binary" do
    assert_raise FixedOpaque,
                 "The value which you pass through parameters must be a binary value, for example: <<0, 0, 0, 5>>",
                 fn ->
                   raise FixedOpaque, :not_binary
                 end
  end

  test "When receives :invalid_length" do
    assert_raise FixedOpaque,
                 "The length that is passed through parameters must be equal or less to the byte size of the XDR to complete",
                 fn ->
                   raise FixedOpaque, :invalid_length
                 end
  end

  test "When receives :exceed_length" do
    assert_raise FixedOpaque,
                 "The length is bigger than the byte size of the XDR",
                 fn ->
                   raise FixedOpaque, :exceed_length
                 end
  end

  test "When receives :not_valid_binary" do
    assert_raise FixedOpaque,
                 "The binary size of the binary which you try to decode must be a multiple of 4",
                 fn ->
                   raise FixedOpaque, :not_valid_binary
                 end
  end
end
