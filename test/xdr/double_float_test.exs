defmodule XDR.DoubleFloatTest do
  use ExUnit.Case

  alias XDR.DoubleFloat
  alias XDR.Error.DoubleFloat, as: DoubleFloatErr

  describe "Encoding float to binary" do
    test "when receives a String" do
      try do
        DoubleFloat.new("hello world")
        |> DoubleFloat.encode_xdr()
      rescue
        error ->
          assert error == %DoubleFloatErr{
                   message: "The value which you try to encode is not an integer or float value"
                 }
      end
    end

    test "when receives a boolean" do
      try do
        DoubleFloat.new(true)
        |> DoubleFloat.encode_xdr()
      rescue
        error ->
          assert error == %DoubleFloatErr{
                   message: "The value which you try to encode is not an integer or float value"
                 }
      end
    end

    test "when receives an atom" do
      try do
        DoubleFloat.new(:hello)
        |> DoubleFloat.encode_xdr()
      rescue
        error ->
          assert error == %DoubleFloatErr{
                   message: "The value which you try to encode is not an integer or float value"
                 }
      end
    end

    test "when is a valid integer" do
      {status, result} =
        DoubleFloat.new(1)
        |> DoubleFloat.encode_xdr()

      assert status == :ok
      assert result == <<63, 240, 0, 0, 0, 0, 0, 0>>
    end

    test "decode_xdr! with valid integer" do
      result =
        DoubleFloat.new(1)
        |> DoubleFloat.encode_xdr!()

      assert result == <<63, 240, 0, 0, 0, 0, 0, 0>>
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
      try do
        DoubleFloat.new(5860)
        |> DoubleFloat.decode_xdr()
      rescue
        error ->
          assert error ==
                   %DoubleFloatErr{
                     message:
                       "The value which you try to decode must be a binary value, for example: <<0, 0, 0, 0, 0, 0, 0, 5>>"
                   }
      end
    end

    test "when is a valid binary" do
      {status, result} =
        DoubleFloat.new(<<192, 11, 174, 20, 122, 225, 71, 174>>)
        |> DoubleFloat.decode_xdr()

      assert status == :ok
      assert result == {-3.46, ""}
    end

    test "when is a valid binary with extra bytes" do
      {status, result} =
        DoubleFloat.new(<<192, 11, 174, 20, 122, 225, 71, 174, 0, 0>>)
        |> DoubleFloat.decode_xdr()

      assert status == :ok
      assert result === {-3.46, <<0, 0>>}
    end

    test "decode_xdr! with valid data" do
      result =
        DoubleFloat.new(<<192, 11, 174, 20, 122, 225, 71, 174>>)
        |> DoubleFloat.decode_xdr!()

      assert result === {-3.46, ""}
    end
  end
end
