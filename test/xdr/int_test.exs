defmodule IntTest do
  use ExUnit.Case

  alias XDR.Int
  alias XDR.Error.Int, as: IntErr

  describe "Encoding integer to binary" do
    test "when is not an integer value" do
      try do
        Int.encode_xdr("hello world")
      rescue
        error ->
          assert error == %IntErr{message: "The value which you try to encode is not an integer"}
      end
    end

    test "when exceeds the upper limit of an integer" do
      try do
        Int.encode_xdr(3_147_483_647)
      rescue
        error ->
          assert error ==
                   %IntErr{
                     message:
                       "The integer which you try to encode exceed the upper limit of an integer, the value must be less than 2147483647"
                   }
      end
    end

    test "when exceeds the lower limit of an integer" do
      try do
        Int.encode_xdr(-3_147_483_647)
      rescue
        error ->
          assert error ==
                   %IntErr{
                     message:
                       "The integer which you try to encode exceed the lower limit of an integer, the value must be more than -2147483648"
                   }
      end
    end

    test "when is a valid integer" do
      {status, result} = Int.encode_xdr(5860)

      assert status == :ok
      assert result == <<0, 0, 22, 228>>
    end
  end

  describe "Decoding binary to integer" do
    test "when is not binary value" do
      try do
        Int.decode_xdr(5860)
      rescue
        error ->
          assert error ==
                   %IntErr{
                     message:
                       "The value which you try to decode must be a binary value, for example: <<0, 0, 0, 2>>"
                   }
      end
    end

    test "when is a valid binary" do
      {status, result} = Int.decode_xdr(<<0, 0, 22, 228>>)

      assert status == :ok
      assert result == {5860, ""}
    end

    test "when is a valid binary with extra bytes" do
      {status, result} = Int.decode_xdr(<<0, 0, 22, 228, 10>>)

      assert status == :ok
      assert result === {5860, <<10>>}
    end
  end
end
