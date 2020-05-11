defmodule XDR.VoidTest do
  use ExUnit.Case

  alias XDR.Void
  alias XDR.Error.Void, as: VoidErr

  describe "Encoding void to binary" do
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
  end

  describe "Decoding binary to integer" do
    test "when is not binary value" do
      try do
        Void.new(5860)
        |> Void.decode_xdr()
      rescue
        error ->
          assert error ==
                   %VoidErr{
                     message:
                       "The value which you try to decode must be a binary value, for example: <<0, 0, 0, 5>>"
                   }
      end
    end

    test "when is a valid binary" do
      {status, result} =
        Void.new(<<>>)
        |> Void.decode_xdr()

      assert status == :ok
      assert result == {nil, ""}
    end

    test "decode_xdr! with valid data" do
      result =
        Void.new(<<>>)
        |> Void.decode_xdr!()

      assert result === {nil, ""}
    end
  end
end
