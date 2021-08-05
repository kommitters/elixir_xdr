defmodule XDR.StringTest do
  @moduledoc """
  Tests for the `XDR.String` module.
  """

  use ExUnit.Case

  alias XDR.String

  describe "Encoding string to binary" do
    test "when is not a bitstring value" do
      {status, result} =
        String.new(2)
        |> String.encode_xdr()

      assert status == :error
      assert result == :not_bitstring
    end

    test "when is a valid bitstring" do
      {status, result} =
        String.new("kommit.co")
        |> String.encode_xdr()

      assert status == :ok
      assert result == <<0, 0, 0, 9, 107, 111, 109, 109, 105, 116, 46, 99, 111, 0, 0, 0>>
    end

    test "encode_xdr when the string exceeds the max length set" do
      {status, result} =
        "kommit.co"
        |> String.new(4)
        |> String.encode_xdr()

      assert status == :error
      assert result == :invalid_length
    end

    test "encode_xdr! with a valid string" do
      result =
        String.new("kommit.co")
        |> String.encode_xdr!()

      assert result == <<0, 0, 0, 9, 107, 111, 109, 109, 105, 116, 46, 99, 111, 0, 0, 0>>
    end

    test "encode_xdr! when is not a bitstring value" do
      assert_raise XDR.Error.String,
                   "The value you are trying to encode must be a bitstring value",
                   fn ->
                     String.new(2)
                     |> String.encode_xdr!()
                   end
    end

    test "encode_xdr! raise an error when the string exceeds the max length set" do
      assert_raise XDR.Error.String,
                   "The length of the string exceeds the max length allowed",
                   fn ->
                     "kommit.co"
                     |> String.new(4)
                     |> String.encode_xdr!()
                   end
    end
  end

  describe "Decoding binary to integer" do
    test "when is not a binary" do
      {status, result} =
        String.decode_xdr([0, 0, 0, 9, 107, 111, 109, 109, 105, 116, 46, 99, 111, 0, 0, 0])

      assert status == :error
      assert result == :not_binary
    end

    test "when is a valid binary" do
      {status, result} =
        String.decode_xdr(<<0, 0, 0, 9, 107, 111, 109, 109, 105, 116, 46, 99, 111, 0, 0, 0>>)

      assert status == :ok
      assert result == {%XDR.String{max_length: 4_294_967_295, string: "kommit.co"}, ""}
    end

    test "decode_xdr! with a valid binary" do
      encoded_binary = <<0, 0, 0, 9, 107, 111, 109, 109, 105, 116, 46, 99, 111, 0, 0, 0>>
      result = String.decode_xdr!(encoded_binary)

      assert result === {%XDR.String{max_length: 4_294_967_295, string: "kommit.co"}, ""}
    end

    test "decode_xdr! when value is not a binary" do
      assert_raise XDR.Error.String,
                   "The value you are trying to decode must be a binary value",
                   fn ->
                     list = [0, 0, 0, 9, 107, 111, 109, 109, 105, 116, 46, 99, 111, 0, 0, 0]
                     String.decode_xdr!(list)
                   end
    end
  end
end
