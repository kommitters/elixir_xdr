defmodule XDR.HyperUIntTest do
  @moduledoc """
  Tests for the `XDR.HyperUInt` module.
  """

  use ExUnit.Case

  alias XDR.{HyperUInt, HyperUIntError}

  describe "Encoding Hyper Unsigned Integer to binary" do
    test "when is not an integer value" do
      {status, reason} =
        HyperUInt.new("hello world")
        |> HyperUInt.encode_xdr()

      assert status == :error
      assert reason == :not_integer
    end

    test "when exceeds the upper limit of an integer" do
      {status, reason} =
        HyperUInt.new(18_446_744_073_709_551_616)
        |> HyperUInt.encode_xdr()

      assert status == :error
      assert reason == :exceed_upper_limit
    end

    test "when exceeds the lower limit of an integer" do
      {status, reason} =
        HyperUInt.new(-809)
        |> HyperUInt.encode_xdr()

      assert status == :error
      assert reason == :exceed_lower_limit
    end

    test "when is a valid integer" do
      {status, result} =
        HyperUInt.new(5860)
        |> HyperUInt.encode_xdr()

      assert status == :ok
      assert result == <<0, 0, 0, 0, 0, 0, 22, 228>>
    end

    test "encode_xdr! with valid data" do
      result =
        HyperUInt.new(5860)
        |> HyperUInt.encode_xdr!()

      assert result == <<0, 0, 0, 0, 0, 0, 22, 228>>
    end

    test "encode_xdr! when is not an integer value" do
      hyper_uint = HyperUInt.new("hello world")

      assert_raise HyperUIntError, fn -> HyperUInt.encode_xdr!(hyper_uint) end
    end
  end

  describe "Decoding binary to Hyper Unsigned Integer" do
    test "when is not binary value" do
      {status, reason} = HyperUInt.decode_xdr(5860)
      assert status == :error
      assert reason == :not_binary
    end

    test "when is a valid binary" do
      {status, result} = HyperUInt.decode_xdr(<<0, 0, 0, 0, 0, 0, 22, 228>>)

      assert status == :ok
      assert result == {%XDR.HyperUInt{datum: 5860}, ""}
    end

    test "when is a valid binary with extra bytes" do
      {status, result} = HyperUInt.decode_xdr(<<0, 0, 0, 0, 0, 0, 22, 228, 10>>)

      assert status == :ok
      assert result === {%XDR.HyperUInt{datum: 5860}, <<10>>}
    end

    test "decode_xdr! with valid data" do
      result = HyperUInt.decode_xdr!(<<0, 0, 0, 0, 0, 0, 22, 228>>)

      assert result === {%XDR.HyperUInt{datum: 5860}, ""}
    end

    test "decode_xdr!when is not binary value" do
      assert_raise HyperUIntError, fn -> HyperUInt.decode_xdr!(5860) end
    end
  end
end
