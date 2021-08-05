defmodule Error.StringTest do
  use ExUnit.Case

  alias XDR.Error.String

  test "When receives :not_bitstring" do
    assert_raise String, "The value you are trying to encode must be a bitstring value", fn ->
      raise String, :not_bitstring
    end
  end

  test "When receives :invalid_length" do
    assert_raise String, "The length of the string exceeds the max length allowed", fn ->
      raise String, :invalid_length
    end
  end

  test "When receives :not_binary" do
    assert_raise String, "The value you are trying to decode must be a binary value", fn ->
      raise String, :not_binary
    end
  end
end
