defmodule Error.StructTest do
  use ExUnit.Case

  alias XDR.Error.Struct

  test "When receives :not_list" do
    assert_raise Struct, "The :components received by parameter must be a keyword list", fn ->
      raise Struct, :not_list
    end
  end

  test "When receives :empty_list" do
    assert_raise Struct, "The :components must not be empty, it must be a keyword list", fn ->
      raise Struct, :empty_list
    end
  end

  test "When receives :not_binary" do
    assert_raise Struct,
                 "The :struct received by parameter must be a binary value, for example: <<0, 0, 0, 5>>",
                 fn ->
                   raise Struct, :not_binary
                 end
  end
end
