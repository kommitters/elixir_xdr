defmodule XDR.StringErrorTest do
  use ExUnit.Case

  alias XDR.StringError

  test "When receives :not_bitstring" do
    assert_raise StringError, "The value you are trying to encode must be a bitstring value", fn ->
      raise StringError, :not_bitstring
    end
  end

  test "When receives :invalid_length" do
    assert_raise StringError, "The length of the string exceeds the max length allowed", fn ->
      raise StringError, :invalid_length
    end
  end

  test "When receives :not_binary" do
    assert_raise StringError, "The value you are trying to decode must be a binary value", fn ->
      raise StringError, :not_binary
    end
  end
end
