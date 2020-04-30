defmodule UIntTest do
  use ExUnit.Case

  alias XDR.UInt
  alias XDR.Error.UInt, as: UIntErr

  describe "Encoding unsigned integer to binary" do
    test "when is not an unsigned integer value" do
      try do
        UInt.encode_xdr("hello world")
      rescue
        error ->
          assert error == %UIntErr{
                   message: "The value which you try to encode is not an unsigned integer"
                 }
      end
    end

    test "when exceeds the upper limit of an unsigned integer" do
      try do
        UInt.encode_xdr(5_147_483_647)
      rescue
        error ->
          assert error ==
                   %UIntErr{
                     message:
                       "The integer which you try to encode exceed the upper limit of an unsigned integer, the value must be less than 4294967295"
                   }
      end
    end

    test "when exceeds the lower limit of an unsigned integer" do
      try do
        UInt.encode_xdr(-3_147_483_647)
      rescue
        error ->
          assert error ==
                   %UIntErr{
                     message:
                       "The integer which you try to encode exceed the lower limit of an unsigned integer, the value must be more than 0"
                   }
      end
    end

    test "when is a valid unsigned integer" do
      {status, result} = UInt.encode_xdr(67_225_860)

      assert status == :ok
      assert result == <<4, 1, 201, 4>>
    end

    test "decode_xdr! with valid UInt" do
      result = UInt.encode_xdr!(67_225_860)

      assert result == <<4, 1, 201, 4>>
    end
  end

  describe "Decoding binary to integer" do
    test "when is not binary value" do
      try do
        UInt.decode_xdr(5860)
      rescue
        error ->
          assert error ==
                   %UIntErr{
                     message:
                       "The value which you try to decode must be a binary value, for example: <<0, 0, 0, 2>>"
                   }
      end
    end

    test "when is a valid binary" do
      {status, result} = UInt.decode_xdr(<<4, 1, 201, 4>>)

      assert status == :ok
      assert result == {67_225_860, ""}
    end

    test "when is a valid binary with extra bytes" do
      {status, result} = UInt.decode_xdr(<<4, 1, 201, 4, 10>>)

      assert status == :ok
      assert result === {67_225_860, <<10>>}
    end

    test "decode_xdr! with valid binary" do
      result = UInt.decode_xdr!(<<4, 1, 201, 4, 10>>)

      assert result === {67_225_860, <<10>>}
    end
  end
end
