defmodule XDR.VoidTest do
  use ExUnit.Case

  alias XDR.Void
  alias XDR.Error.Void, as: VoidErr

  describe "Encoding void to binary" do
    test "when not receive a void struct" do
      try do
        Void.encode_xdr("hello world")
      rescue
        error ->
          assert error == %VoidErr{
                   message: "The value which you try to encode is not void"
                 }
      end
    end

    test "when receives a String" do
      try do
        Void.new("hello world")
        |> Void.encode_xdr()
      rescue
        error ->
          assert error == %VoidErr{
                   message: "The value which you try to encode is not void"
                 }
      end
    end

    test "with valid data" do
      {status, result} =
        Void.new(nil)
        |> Void.encode_xdr()

      assert status == :ok
      assert result == <<>>
    end

    test "encode_xdr! with valid data" do
      result =
        Void.new(nil)
        |> Void.encode_xdr!()

      assert result == <<>>
    end

    test "encode_xdr! with invalid data" do
      try do
        Void.encode_xdr!(nil)
      rescue
        error ->
          assert error == %VoidErr{
                   message: "The value which you try to encode is not void"
                 }
      end
    end
  end

  describe "Decoding binary to integer" do
    test "when is not binary value" do
      try do
        Void.decode_xdr(5860, XDR.Void)
      rescue
        error ->
          assert error ==
                   %VoidErr{
                     message: "The value which you try to encode is not void"
                   }
      end
    end

    test "with invalid binary" do
      try do
        Void.decode_xdr(<<0>>, XDR.Void)
      rescue
        error ->
          assert error ==
                   %VoidErr{
                     message: "The value which you try to encode is not void"
                   }
      end
    end

    test "when is a valid binary" do
      {status, result} = Void.decode_xdr(<<>>, XDR.Void)

      assert status == :ok
      assert result == {nil, ""}
    end

    test "decode_xdr! with valid data" do
      result = Void.decode_xdr!(<<>>, XDR.Void)

      assert result === {nil, ""}
    end

    test "decode_xdr! with invalid data" do
      try do
        Void.decode_xdr!(<<0>>, XDR.Void)
      rescue
        error ->
          assert error == %VoidErr{
                   message: "The value which you try to encode is not void"
                 }
      end
    end
  end
end
