defmodule XDR.OptionalErrorTest do
  use ExUnit.Case

  alias XDR.OptionalError

  test "When receives :not_valid" do
    assert_raise OptionalError, "The value which you try to encode must be Int, UInt or Enum", fn ->
      raise OptionalError, :not_valid
    end
  end

  test "When receives :not_binary" do
    assert_raise OptionalError,
                 "The value which you try to decode must be a binary value",
                 fn ->
                   raise OptionalError, :not_binary
                 end
  end

  test "When receives :not_module" do
    assert_raise OptionalError,
                 "The type of the optional value must be the module which it belongs",
                 fn ->
                   raise OptionalError, :not_module
                 end
  end
end
