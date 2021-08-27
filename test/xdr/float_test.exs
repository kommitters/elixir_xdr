defmodule XDR.FloatTest do
  @moduledoc """
  Tests for the `XDR.Float` module.
  """

  use ExUnit.Case

  alias XDR.{Float, FloatError}

  describe "defguard tests" do
    test "valid_float? guard" do
      require XDR.Float

      assert XDR.Float.valid_float?(3.43) == true
      assert XDR.Float.valid_float?(4) == true
      assert XDR.Float.valid_float?("5") == false
    end
  end

  describe "Encoding float to binary" do
    test "when receives a String" do
      {status, reason} =
        Float.new("hello world")
        |> Float.encode_xdr()

      assert status == :error
      assert reason == :not_number
    end

    test "when receives a boolean" do
      {status, reason} =
        Float.new(true)
        |> Float.encode_xdr()

      assert status == :error
      assert reason == :not_number
    end

    test "when receives an atom" do
      {status, reason} =
        Float.new(:hello)
        |> Float.encode_xdr()

      assert status == :error
      assert reason == :not_number
    end

    test "when is a valid integer" do
      {status, result} =
        Float.new(1)
        |> Float.encode_xdr()

      assert status == :ok
      assert result == <<63, 128, 0, 0>>
    end

    test "encode_xdr! with valid integer" do
      result =
        Float.new(1)
        |> Float.encode_xdr!()

      assert result == <<63, 128, 0, 0>>
    end

    test "encode_xdr! when receives an atom" do
      float = Float.new(:hello)

      assert_raise FloatError, fn -> Float.encode_xdr!(float) end
    end

    test "with negative integer" do
      {status, result} =
        Float.new(-1)
        |> Float.encode_xdr()

      assert status == :ok
      assert result == <<191, 128, 0, 0>>
    end

    test "with positive float" do
      {status, result} =
        Float.new(3.46)
        |> Float.encode_xdr()

      assert status == :ok
      assert result == <<64, 93, 112, 164>>
    end

    test "with negative float" do
      {status, result} =
        Float.new(-3.46)
        |> Float.encode_xdr()

      assert status == :ok
      assert result == <<192, 93, 112, 164>>
    end
  end

  describe "Decoding binary to integer" do
    test "when is not binary value" do
      {status, reason} =
        Float.new(5860)
        |> Float.decode_xdr()

      assert status == :error
      assert reason == :not_binary
    end

    test "when is a valid binary" do
      {status, result} = Float.decode_xdr(<<192, 93, 112, 164>>)

      assert status == :ok
      assert result == {%XDR.Float{float: -3.4600000381469727}, ""}
    end

    test "when is a valid binary with extra bytes" do
      {status, result} = Float.decode_xdr(<<192, 93, 112, 164, 0, 0>>)

      assert status == :ok
      assert result === {%XDR.Float{float: -3.4600000381469727}, <<0, 0>>}
    end

    test "decode_xdr! with valid data" do
      result = Float.decode_xdr!(<<192, 93, 112, 164>>)

      assert result === {%XDR.Float{float: -3.4600000381469727}, ""}
    end

    test "decode_xdr! when is not binary value" do
      float = Float.new(5860)

      assert_raise FloatError, fn -> Float.decode_xdr!(float) end
    end
  end
end
