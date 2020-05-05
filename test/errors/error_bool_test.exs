defmodule Error.BoolTest do
  use ExUnit.Case

  alias XDR.Error.Bool

  test "When receives :not_boolean" do
    assert_raise Bool, "The value which you try to encode is not a boolean", fn ->
      raise Bool, :not_boolean
    end
  end

  test "When receives :invalid_value" do
    assert_raise Bool,
                 "The value which you try to decode must be <<0,0,0,0>> or <<0,0,0,1>>",
                 fn ->
                   raise Bool, :invalid_value
                 end
  end
end
