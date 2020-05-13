defmodule Error.OptionalTest do
  use ExUnit.Case

  alias XDR.Error.Optional

  test "When receives :not_valid" do
    assert_raise Optional, "The value which you try to encode must be Int, UInt or Enum", fn ->
      raise Optional, :not_valid
    end
  end

  test "When receives :not_binary" do
    assert_raise Optional,
                 "The value which you try to decode must be a binary value",
                 fn ->
                   raise Optional, :not_binary
                 end
  end
end
