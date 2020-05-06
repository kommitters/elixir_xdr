defmodule Error.StringTest do
  use ExUnit.Case

  alias XDR.Error.String

  test "When receives :not_bitstring" do
    assert_raise String, "the value which you ty to encode must be a bitstring value", fn ->
      raise String, :not_bitstring
    end
  end
end
