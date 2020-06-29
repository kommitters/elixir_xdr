defmodule XDR.StringTest do
  @moduledoc """
  Tests for the `XDR.String` module.
  """

  use ExUnit.Case

  alias XDR.String
  alias XDR.Error.String, as: StringError

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

    test "encode_xdr! with valid String" do
      result =
        String.new("kommit.co")
        |> String.encode_xdr!()

      assert result == <<0, 0, 0, 9, 107, 111, 109, 109, 105, 116, 46, 99, 111, 0, 0, 0>>
    end

    test "encode_xdr! when is not a bitstring value" do
      string = String.new(2)

      assert_raise StringError, fn -> String.encode_xdr!(string) end
    end
  end

  describe "Decoding binary to integer" do
    test "when is not binary" do
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

    test "decode_xdr! with valid binary" do
      result =
        String.decode_xdr!(<<0, 0, 0, 9, 107, 111, 109, 109, 105, 116, 46, 99, 111, 0, 0, 0>>)

      assert result === {%XDR.String{max_length: 4_294_967_295, string: "kommit.co"}, ""}
    end

    test "encode_xdr! when is not binary" do
      list = [0, 0, 0, 9, 107, 111, 109, 109, 105, 116, 46, 99, 111, 0, 0, 0]
      assert_raise StringError, fn -> String.decode_xdr!(list) end
    end
  end
end
