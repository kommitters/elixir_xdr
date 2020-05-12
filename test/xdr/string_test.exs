defmodule XDR.StringTest do
  use ExUnit.Case

  alias XDR.String
  alias XDR.Error.String, as: StringErr

  describe "Encoding string to binary" do
    test "when is not a bitstring value" do
      try do
        String.new(2)
        |> String.encode_xdr()
      rescue
        error ->
          assert error == %StringErr{
                   message: "the value which you ty to encode must be a bitstring value"
                 }
      end
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
  end

  describe "Decoding binary to integer" do
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
  end
end
