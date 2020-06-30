defmodule XDR.DoubleFloatTest do
  @moduledoc """
  Tests for the `XDR.DoubleFloat` module.
  """

  use ExUnit.Case

  alias XDR.DoubleFloat
  alias XDR.Error.DoubleFloat, as: DoubleFloatError

  describe "defguard tests" do
    test "valid_float? guard" do
      require XDR.DoubleFloat

      assert XDR.DoubleFloat.valid_float?(3.43) == true
      assert XDR.DoubleFloat.valid_float?(4) == true
      assert XDR.DoubleFloat.valid_float?("5") == false
    end
  end

  describe "Encoding float to binary" do
    test "when receives a String" do
      {status, reason} =
        DoubleFloat.new("hello world")
        |> DoubleFloat.encode_xdr()

      assert status == :error
      assert reason == :not_number
    end

    test "when receives a boolean" do
      {status, reason} =
        DoubleFloat.new(true)
        |> DoubleFloat.encode_xdr()

      assert status == :error
      assert reason == :not_number
    end

    test "when receives an atom" do
      {status, reason} =
        DoubleFloat.new(:hello)
        |> DoubleFloat.encode_xdr()

      assert status == :error
      assert reason == :not_number
    end

    test "when is a valid integer" do
      {status, result} =
        DoubleFloat.new(1)
        |> DoubleFloat.encode_xdr()

      assert status == :ok
      assert result == <<63, 240, 0, 0, 0, 0, 0, 0>>
    end

    test "encode_xdr! with valid integer" do
      result =
        DoubleFloat.new(1)
        |> DoubleFloat.encode_xdr!()

      assert result == <<63, 240, 0, 0, 0, 0, 0, 0>>
    end

    test "encode_xdr! when receives a String" do
      float = DoubleFloat.new("hello world")

      assert_raise DoubleFloatError, fn -> DoubleFloat.encode_xdr!(float) end
    end

    test "with negative integer" do
      {status, result} =
        DoubleFloat.new(-1)
        |> DoubleFloat.encode_xdr()

      assert status == :ok
      assert result == <<191, 240, 0, 0, 0, 0, 0, 0>>
    end

    test "with positive float" do
      {status, result} =
        DoubleFloat.new(3.46)
        |> DoubleFloat.encode_xdr()

      assert status == :ok
      assert result == <<64, 11, 174, 20, 122, 225, 71, 174>>
    end

    test "with negative float" do
      {status, result} =
        DoubleFloat.new(-3.46)
        |> DoubleFloat.encode_xdr()

      assert status == :ok
      assert result == <<192, 11, 174, 20, 122, 225, 71, 174>>
    end
  end

  describe "Decoding binary to integer" do
    test "when is not binary value" do
      {status, reason} = DoubleFloat.decode_xdr(5860)

      assert status == :error
      assert reason == :not_binary
    end

    test "when is a valid binary" do
      {status, result} = DoubleFloat.decode_xdr(<<192, 11, 174, 20, 122, 225, 71, 174>>)

      assert status == :ok
      assert result == {%XDR.DoubleFloat{float: -3.46}, ""}
    end

    test "when is a valid binary with extra bytes" do
      {status, result} = DoubleFloat.decode_xdr(<<192, 11, 174, 20, 122, 225, 71, 174, 0, 0>>)

      assert status == :ok
      assert result === {%XDR.DoubleFloat{float: -3.46}, <<0, 0>>}
    end

    test "decode_xdr! with valid data" do
      result = DoubleFloat.decode_xdr!(<<192, 11, 174, 20, 122, 225, 71, 174>>)

      assert result === {%XDR.DoubleFloat{float: -3.46}, ""}
    end

    test "decode_xdr! when is not binary value" do
      assert_raise DoubleFloatError, fn -> DoubleFloat.decode_xdr!(5860) end
    end
  end
end
