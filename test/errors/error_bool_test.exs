defmodule Error.BoolTest do
  use ExUnit.Case

  alias XDR.Error.Bool

  test "When receives :not_boolean" do
    assert_raise Bool, "The value which you try to encode is not a boolean", fn ->
      raise Bool, :not_boolean
    end
  end
end
