defmodule XDR.FloatTest do
  use ExUnit.Case

  alias XDR.Float
  alias XDR.Error.Float, as: FloatErr

  describe "Encoding float to binary" do
    test "when receives a String" do
      try do
        Float.encode_xdr("hello world")
      rescue
        error ->
          assert error == %FloatErr{
                   message: "The value which you try to encode is not an integer or float value"
                 }
      end
    end

    test "when receives a boolean" do
      try do
        Float.encode_xdr(true)
      rescue
        error ->
          assert error == %FloatErr{
                   message: "The value which you try to encode is not an integer or float value"
                 }
      end
    end

    test "when receives an atom" do
      try do
        Float.encode_xdr(true)
      rescue
        error ->
          assert error == %FloatErr{
                   message: "The value which you try to encode is not an integer or float value"
                 }
      end
    end

    test "when is a valid integer" do
      {status, result} = Float.encode_xdr(1)

      assert status == :ok
      assert result == <<63, 128, 0, 0>>
    end

    test "encode_xdr! with valid integer" do
      result = Float.encode_xdr!(1)

      assert result == <<63, 128, 0, 0>>
    end

    test "with negative integer" do
      {status, result} = Float.encode_xdr(-1)

      assert status == :ok
      assert result == <<191, 128, 0, 0>>
    end

    test "with positive float" do
      {status, result} = Float.encode_xdr(3.46)

      assert status == :ok
      assert result == <<64, 93, 112, 164>>
    end

    test "with negative float" do
      {status, result} = Float.encode_xdr(-3.46)

      assert status == :ok
      assert result == <<192, 93, 112, 164>>
    end
  end

  describe "Decoding binary to integer" do
    test "when is not binary value" do
      try do
        Float.decode_xdr(5860)
      rescue
        error ->
          assert error ==
                   %FloatErr{
                     message:
                       "The value which you try to decode must be a binary value, for example: <<0, 0, 0, 2>>"
                   }
      end
    end

    test "when is a valid binary" do
      {status, result} = Float.decode_xdr(<<192, 93, 112, 164>>)

      assert status == :ok
      assert result == {-3.4600000381469727, ""}
    end

    test "when is a valid binary with extra bytes" do
      {status, result} = Float.decode_xdr(<<192, 93, 112, 164, 0, 0>>)

      assert status == :ok
      assert result === {-3.4600000381469727, <<0, 0>>}
    end

    test "decode_xdr! with valid data" do
      result = Float.decode_xdr!(<<192, 93, 112, 164>>)

      assert result === {-3.4600000381469727, ""}
    end
  end
end
