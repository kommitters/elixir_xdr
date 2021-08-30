defmodule XDR.HyperIntTest do
  @moduledoc """
  Tests for the `XDR.HyperInt` module.
  """

  use ExUnit.Case

  alias XDR.{HyperInt, HyperIntError}

  describe "Encoding Hyper Integer to binary" do
    test "when is not an integer value" do
      {status, reason} =
        HyperInt.new("hello world")
        |> HyperInt.encode_xdr()

      assert status == :error
      assert reason == :not_integer
    end

    test "when exceeds the upper limit of an integer" do
      {status, reason} =
        HyperInt.new(9_223_372_036_854_775_808)
        |> HyperInt.encode_xdr()

      assert status == :error
      assert reason == :exceed_upper_limit
    end

    test "when exceeds the lower limit of an integer" do
      {status, reason} =
        HyperInt.new(-9_223_372_036_854_775_809)
        |> HyperInt.encode_xdr()

      assert status == :error
      assert reason == :exceed_lower_limit
    end

    test "when is a valid integer" do
      {status, result} =
        HyperInt.new(5860)
        |> HyperInt.encode_xdr()

      assert status == :ok
      assert result == <<0, 0, 0, 0, 0, 0, 22, 228>>
    end

    test "encode_xdr! with valid data" do
      result =
        HyperInt.new(5860)
        |> HyperInt.encode_xdr!()

      assert result == <<0, 0, 0, 0, 0, 0, 22, 228>>
    end

    test "encode_xdr! when is not an integer value" do
      hyper_int = HyperInt.new("hello world")

      assert_raise HyperIntError, fn -> HyperInt.encode_xdr!(hyper_int) end
    end
  end

  describe "Decoding binary to Hyper Integer" do
    test "when is not binary value" do
      {status, reason} =
        HyperInt.new(5860)
        |> HyperInt.decode_xdr()

      assert status == :error
      assert reason == :not_binary
    end

    test "when is a valid binary" do
      {status, result} = HyperInt.decode_xdr(<<0, 0, 0, 0, 0, 0, 22, 228>>)

      assert status == :ok
      assert result == {%XDR.HyperInt{datum: 5860}, ""}
    end

    test "when is a valid binary with extra bytes" do
      {status, result} = HyperInt.decode_xdr(<<0, 0, 0, 0, 0, 0, 22, 228, 10>>)

      assert status == :ok
      assert result === {%XDR.HyperInt{datum: 5860}, <<10>>}
    end

    test "decode_xdr! with valid data" do
      result = HyperInt.decode_xdr!(<<0, 0, 0, 0, 0, 0, 22, 228>>)

      assert result === {%XDR.HyperInt{datum: 5860}, ""}
    end

    test "decode_xdr! when is not binary value" do
      hyper_int = HyperInt.new(5860)

      assert_raise HyperIntError, fn -> HyperInt.decode_xdr!(hyper_int) end
    end
  end
end
