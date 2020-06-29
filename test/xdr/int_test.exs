defmodule XDR.IntTest do
  @moduledoc """
  Tests for the `XDR.Int` module.
  """

  use ExUnit.Case

  alias XDR.Int
  alias XDR.Error.Int, as: IntError

  describe "Encoding integer to binary" do
    test "when is not an integer value" do
      {status, reason} =
        Int.new("hello world")
        |> Int.encode_xdr()

      assert status == :error
      assert reason == :not_integer
    end

    test "when exceeds the upper limit of an integer" do
      {status, reason} =
        Int.new(3_147_483_647)
        |> Int.encode_xdr()

      assert status == :error
      assert reason == :exceed_upper_limit
    end

    test "when exceeds the lower limit of an integer" do
      {status, reason} =
        Int.new(-3_147_483_647)
        |> Int.encode_xdr()

      assert status == :error
      assert reason == :exceed_lower_limit
    end

    test "when is a valid integer" do
      {status, result} =
        Int.new(5860)
        |> Int.encode_xdr()

      assert status == :ok
      assert result == <<0, 0, 22, 228>>
    end

    test "decode_xdr! with valid data" do
      result =
        Int.new(5860)
        |> Int.encode_xdr!()

      assert result == <<0, 0, 22, 228>>
    end

    test "decode_xdr! when is not an integer value" do
      integer = Int.new("hello world")

      assert_raise IntError, fn -> Int.encode_xdr!(integer) end
    end
  end

  describe "Decoding binary to integer" do
    test "when is not binary value" do
      {status, reason} =
        Int.new(5860)
        |> Int.decode_xdr()

      assert status == :error
      assert reason == :not_binary
    end

    test "when is a valid binary" do
      {status, result} = Int.decode_xdr(<<0, 0, 22, 228>>)

      assert status == :ok
      assert result == {%XDR.Int{datum: 5860}, ""}
    end

    test "when is a valid binary with extra bytes" do
      {status, result} = Int.decode_xdr(<<0, 0, 22, 228, 10>>)

      assert status == :ok
      assert result === {%XDR.Int{datum: 5860}, <<10>>}
    end

    test "decode_xdr! with valid data" do
      result = Int.decode_xdr!(<<0, 0, 22, 228>>)

      assert result === {%XDR.Int{datum: 5860}, ""}
    end

    test "decode_xdr! when is not binary value" do
      integer = Int.new(5860)

      assert_raise IntError, fn -> Int.decode_xdr!(integer) end
    end
  end
end
