defmodule XDR.UIntTest do
  use ExUnit.Case

  alias XDR.UInt
  alias XDR.Error.UInt, as: UIntErr

  describe "Encoding unsigned integer to binary" do
    test "when is not an unsigned integer value" do
      {status, reason} =
        UInt.new("hello world")
        |> UInt.encode_xdr()

      assert status == :error
      assert reason == :not_integer
    end

    test "when exceeds the upper limit of an unsigned integer" do
      {status, reason} =
        UInt.new(5_147_483_647)
        |> UInt.encode_xdr()

      assert status == :error
      assert reason == :exceed_upper_limit
    end

    test "when exceeds the lower limit of an unsigned integer" do
      {status, reason} =
        UInt.new(-3_147_483_647)
        |> UInt.encode_xdr()

      assert status == :error
      assert reason == :exceed_lower_limit
    end

    test "when is a valid unsigned integer" do
      {status, result} =
        UInt.new(67_225_860)
        |> UInt.encode_xdr()

      assert status == :ok
      assert result == <<4, 1, 201, 4>>
    end

    test "encode_xdr! with valid UInt" do
      result =
        UInt.new(67_225_860)
        |> UInt.encode_xdr!()

      assert result == <<4, 1, 201, 4>>
    end

    test "encode_xdr! with invalid data" do
      uint = UInt.new("hello world")

      assert_raise UIntErr, fn -> UInt.encode_xdr!(uint) end
    end
  end

  describe "Decoding binary to integer" do
    test "when is not binary value" do
      {status, reason} =
        UInt.new(5860)
        |> UInt.decode_xdr()

      assert status == :error
      assert reason == :not_binary
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

    test "decode_xdr! when is not binary value" do
      assert_raise UIntErr, fn -> UInt.decode_xdr!([1, 2, 3, 6]) end
    end
  end
end
