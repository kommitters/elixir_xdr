defmodule XDR.StringTest do
  use ExUnit.Case

  alias XDR.String
  alias XDR.Error.String, as: StringErr

  describe "Encoding string to binary" do
    test "when is not a bitstring value" do
      try do
        String.encode_xdr(2)
      rescue
        error ->
          assert error == %StringErr{
                   message: "the value which you ty to encode must be a bitstring value"
                 }
      end
    end

    test "when is a valid bitstring" do
      {status, result} = String.encode_xdr("kommit.co")

      assert status == :ok
      assert result == <<0, 0, 0, 9, 107, 111, 109, 109, 105, 116, 46, 99, 111, 0, 0, 0>>
    end

    test "decode_xdr! with valid String" do
      result = String.encode_xdr!("kommit.co")

      assert result == <<0, 0, 0, 9, 107, 111, 109, 109, 105, 116, 46, 99, 111, 0, 0, 0>>
    end
  end

  describe "Decoding binary to integer" do
    test "when is a valid binary" do
      {status, result} =
        String.decode_xdr(<<0, 0, 0, 9, 107, 111, 109, 109, 105, 116, 46, 99, 111, 0, 0, 0>>)

      assert status == :ok
      assert result == {"kommit.co", ""}
    end

    test "decode_xdr! with valid binary" do
      result =
        String.decode_xdr!(<<0, 0, 0, 9, 107, 111, 109, 109, 105, 116, 46, 99, 111, 0, 0, 0>>)

      assert result === {"kommit.co", ""}
    end
  end
end
