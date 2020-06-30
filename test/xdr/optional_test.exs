defmodule XDR.OptionalTest do
  @moduledoc """
  Tests for the `XDR.Optional` module.
  """

  use ExUnit.Case

  alias XDR.Optional
  alias XDR.Error.Optional, as: OptionalError

  describe "Encoding Optional type to binary" do
    test "when receives a string" do
      {status, reason} =
        Optional.new("hello world")
        |> Optional.encode_xdr()

      assert status == :error
      assert reason == :not_valid
    end

    test "when receives a list" do
      {status, reason} =
        Optional.new([])
        |> Optional.encode_xdr()

      assert status == :error
      assert reason == :not_valid
    end

    test "when receives a tuple" do
      {status, reason} =
        Optional.new({:ok, []})
        |> Optional.encode_xdr()

      assert status == :error
      assert reason == :not_valid
    end

    test "when receives a bool" do
      {status, reason} =
        Optional.new(true)
        |> Optional.encode_xdr()

      assert status == :error
      assert reason == :not_valid
    end

    test "when receives nil" do
      {status, result} =
        Optional.new(nil)
        |> Optional.encode_xdr()

      assert status == :ok
      assert result == <<0, 0, 0, 0>>
    end

    test "when is a valid integer" do
      {status, result} =
        Optional.new(%XDR.Int{datum: 5860})
        |> Optional.encode_xdr()

      assert status == :ok
      assert result == <<0, 0, 0, 1, 0, 0, 22, 228>>
    end

    test "when is a valid Unsigned integer" do
      {status, result} =
        Optional.new(%XDR.UInt{datum: 5860})
        |> Optional.encode_xdr()

      assert status == :ok
      assert result == <<0, 0, 0, 1, 0, 0, 22, 228>>
    end

    test "when is a valid Enum" do
      {status, result} =
        XDR.Bool.new(true)
        |> Optional.new()
        |> Optional.encode_xdr()

      assert status == :ok
      assert result == <<0, 0, 0, 1, 0, 0, 0, 1>>
    end

    test "encode_xdr! with valid data" do
      result =
        Optional.new(%XDR.Int{datum: 5860})
        |> Optional.encode_xdr!()

      assert result == <<0, 0, 0, 1, 0, 0, 22, 228>>
    end

    test "encode_xdr! when receives a string" do
      optional = Optional.new("hello world")

      assert_raise OptionalError, fn -> Optional.encode_xdr!(optional) end
    end
  end

  describe "Decoding binary to integer" do
    test "when is not binary value" do
      {status, reason} = Optional.decode_xdr([0, 0, 0, 1, 0, 0, 22, 228], %{type: XDR.Int})
      assert status == :error
      assert reason == :not_binary
    end

    test "when is not an atom" do
      {status, reason} = Optional.decode_xdr(<<0, 0, 0, 1, 0, 0, 22, 228>>, %{type: "XDR.Int"})
      assert status == :error
      assert reason == :not_module
    end

    test "with valid binary and Integer type" do
      {status, result} = Optional.decode_xdr(<<0, 0, 0, 1, 0, 0, 22, 228>>, %{type: XDR.Int})

      assert status == :ok
      assert result == {%XDR.Optional{type: %XDR.Int{datum: 5860}}, ""}
    end

    test "with valid binary and Unsigned Integer type" do
      {status, result} = Optional.decode_xdr(<<0, 0, 0, 1, 0, 0, 22, 228>>, %{type: XDR.UInt})

      assert status == :ok
      assert result == {%XDR.Optional{type: %XDR.UInt{datum: 5860}}, ""}
    end

    test "with valid binary and Enum type" do
      {status, result} = Optional.decode_xdr(<<0, 0, 0, 1, 0, 0, 0, 1>>, %{type: XDR.Bool})

      assert status == :ok
      assert result === {%XDR.Optional{type: %XDR.Bool{identifier: true}}, ""}
    end

    test "with void value" do
      {status, result} = Optional.decode_xdr(<<0, 0, 0, 0>>, %{type: XDR.Bool})

      assert status == :ok
      assert result === {nil, ""}
    end

    test "decode_xdr! with valid Enum type" do
      result = Optional.decode_xdr!(<<0, 0, 0, 1, 0, 0, 0, 1>>, %{type: XDR.Bool})

      assert result === {%XDR.Optional{type: %XDR.Bool{identifier: true}}, ""}
    end

    test "decode_xdr! when is not binary value" do
      assert_raise OptionalError, fn ->
        Optional.decode_xdr!([0, 0, 0, 1, 0, 0, 22, 228], %{type: XDR.Int})
      end
    end
  end
end
