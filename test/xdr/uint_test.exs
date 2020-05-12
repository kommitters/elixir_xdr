defmodule XDR.UIntTest do
  use ExUnit.Case

  alias XDR.UInt
  alias XDR.Error.UInt, as: UIntErr

  describe "Encoding unsigned integer to binary" do
    test "when is not an unsigned integer value" do
      try do
        UInt.new("hello world")
        |> UInt.encode_xdr()
      rescue
        error ->
          assert error == %UIntErr{
                   message: "The value which you try to encode is not an integer"
                 }
      end
    end

    test "when exceeds the upper limit of an unsigned integer" do
      try do
        UInt.new(5_147_483_647)
        |> UInt.encode_xdr()
      rescue
        error ->
          assert error ==
                   %UIntErr{
                     message:
                       "The integer which you try to encode exceed the upper limit of an unsigned integer, the value must be less than 4_294_967_295"
                   }
      end
    end

    test "when exceeds the lower limit of an unsigned integer" do
      try do
        UInt.new(-3_147_483_647)
        |> UInt.encode_xdr()
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
      {status, result} =
        UInt.new(67_225_860)
        |> UInt.encode_xdr()

      assert status == :ok
      assert result == <<4, 1, 201, 4>>
    end

    test "decode_xdr! with valid UInt" do
      result =
        UInt.new(67_225_860)
        |> UInt.encode_xdr!()

      assert result == <<4, 1, 201, 4>>
    end
  end

  describe "Decoding binary to integer" do
    test "when is not binary value" do
      try do
        UInt.new(5860)
        |> UInt.decode_xdr()
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
      assert result == {%UInt{datum: 67_225_860}, ""}
    end

    test "when is a valid binary with extra bytes" do
      {status, result} = UInt.decode_xdr(<<4, 1, 201, 4, 10>>)

      assert status == :ok
      assert result === {%XDR.UInt{datum: 67_225_860}, <<10>>}
    end

    test "decode_xdr! with valid binary" do
      result = UInt.decode_xdr!(<<4, 1, 201, 4, 10>>)

      assert result === {%XDR.UInt{datum: 67_225_860}, <<10>>}
    end
  end
end
