defmodule XDR.StructErrorTest do
  use ExUnit.Case

  alias XDR.StructError

  test "When receives :not_list" do
    assert_raise StructError,
                 "The :components received by parameter must be a keyword list",
                 fn ->
                   raise StructError, :not_list
                 end
  end

  test "When receives :empty_list" do
    assert_raise StructError,
                 "The :components must not be empty, it must be a keyword list",
                 fn ->
                   raise StructError, :empty_list
                 end
  end

  test "When receives :not_binary" do
    assert_raise StructError,
                 "The :struct received by parameter must be a binary value, for example: <<0, 0, 0, 5>>",
                 fn ->
                   raise StructError, :not_binary
                 end
  end
end
