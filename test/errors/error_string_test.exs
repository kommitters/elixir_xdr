defmodule Error.StringTest do
  use ExUnit.Case

  alias XDR.Error.String

  test "When receives :not_bitstring" do
    assert_raise String, "the value which you try to encode must be a bitstring value", fn ->
      raise String, :not_bitstring
    end
  end

  test "When receives :not_binary" do
    assert_raise String, "the value which you try to decode must be a binary value", fn ->
      raise String, :not_binary
    end
  end
end
