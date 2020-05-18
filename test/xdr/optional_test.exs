defmodule XDR.OptionalTest do
  use ExUnit.Case

  alias XDR.Optional
  alias XDR.Error.Optional, as: OptionalErr

  describe "Encoding Optional type to binary" do
    test "when receives a string" do
      try do
        Optional.new("hello world")
        |> Optional.encode_xdr()
      rescue
        error ->
          assert error == %OptionalErr{
                   message: "The value which you try to encode must be Int, UInt or Enum"
                 }
      end
    end

    test "when receives a list" do
      try do
        Optional.new([])
        |> Optional.encode_xdr()
      rescue
        error ->
          assert error == %OptionalErr{
                   message: "The value which you try to encode must be Int, UInt or Enum"
                 }
      end
    end

    test "when receives a tuple" do
      try do
        Optional.new({:ok, []})
        |> Optional.encode_xdr()
      rescue
        error ->
          assert error == %OptionalErr{
                   message: "The value which you try to encode must be Int, UInt or Enum"
                 }
      end
    end

    test "when receives a bool" do
      try do
        Optional.new(true)
        |> Optional.encode_xdr()
      rescue
        error ->
          assert error == %OptionalErr{
                   message: "The value which you try to encode must be Int, UInt or Enum"
                 }
      end
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

    test "decode_xdr! with valid data" do
      result =
        Optional.new(%XDR.Int{datum: 5860})
        |> Optional.encode_xdr!()

      assert result == <<0, 0, 0, 1, 0, 0, 22, 228>>
    end
  end

  describe "Decoding binary to integer" do
    test "when is not binary value" do
      try do
        Optional.decode_xdr([0, 0, 0, 1, 0, 0, 22, 228], %{type: XDR.Int})
      rescue
        error ->
          assert error ==
                   %OptionalErr{
                     message: "The value which you try to decode must be a binary value"
                   }
      end
    end

    test "when is not an atom" do
      try do
        Optional.decode_xdr(<<0, 0, 0, 1, 0, 0, 22, 228>>, %{type: "XDR.Int"})
      rescue
        error ->
          assert error ==
                   %OptionalErr{
                     message: "The value which you try to decode must be a binary value"
                   }
      end
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

    test "encode_xdr! with valid Enum type" do
      result = Optional.decode_xdr!(<<0, 0, 0, 1, 0, 0, 0, 1>>, %{type: XDR.Bool})

      assert result === {%XDR.Optional{type: %XDR.Bool{identifier: true}}, ""}
    end
  end
end
