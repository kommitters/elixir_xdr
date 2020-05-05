defmodule XDR.FixedOpaqueTest do
  use ExUnit.Case

  alias XDR.FixedOpaque
  alias XDR.Error.FixedOpaque, as: FixedOpaqueErr

  describe "Encoding Fixed Opaque" do
    test "when xdr is not binary" do
      try do
        FixedOpaque.encode_xdr([0, 0, 1], 2)
      rescue
        error ->
          assert error == %FixedOpaqueErr{
                   message:
                     "The value which you pass through parameters must be a binary value, for example: <<0, 0, 0, 5>>"
                 }
      end
    end

    test "with invalid length" do
      try do
        FixedOpaque.encode_xdr(<<0, 0, 1>>, 2)
      rescue
        error ->
          assert error == %FixedOpaqueErr{
                   message:
                     "The length that is passed through parameters must be equal or less to the byte size of the XDR to complete"
                 }
      end
    end

    test "when length is not an integer" do
      try do
        FixedOpaque.encode_xdr(<<0, 0, 1>>, "hi")
      rescue
        error ->
          assert error == %FixedOpaqueErr{
                   message: "The value which you pass through parameters is not an integer"
                 }
      end
    end

    test "with valid data" do
      {status, result} = FixedOpaque.encode_xdr(<<0, 0, 1>>, 3)

      assert status == :ok
      assert result == <<0, 0, 1, 0>>
    end

    test "encode_xdr! with valid data" do
      result = FixedOpaque.encode_xdr!(<<0, 0, 1>>, 3)

      assert result == <<0, 0, 1, 0>>
    end
  end

  describe "Decoding Fixed Opaque" do
    test "when xdr is not binary" do
      try do
        FixedOpaque.decode_xdr([0, 0, 1], 2)
      rescue
        error ->
          assert error == %FixedOpaqueErr{
                   message:
                     "The value which you pass through parameters must be a binary value, for example: <<0, 0, 0, 5>>"
                 }
      end
    end

    test "when xdr byte size is not a multiple of 4" do
      try do
        FixedOpaque.decode_xdr(<<0, 0, 1>>, 2)
      rescue
        error ->
          assert error == %FixedOpaqueErr{
                   message:
                     "The binary size of the binary which you try to decode must be a multiple of 4"
                 }
      end
    end

    test "when length is not an integer" do
      try do
        FixedOpaque.encode_xdr(<<0, 0, 1, 0>>, "2")
      rescue
        error ->
          assert error == %FixedOpaqueErr{
                   message: "The value which you pass through parameters is not an integer"
                 }
      end
    end

    test "when the length is bigger than the XDR byte-size" do
      try do
        FixedOpaque.encode_xdr(<<0, 0, 1, 0>>, 5)
      rescue
        error ->
          assert error == %FixedOpaqueErr{
                   message:
                     "The length that is passed through parameters must be equal or less to the byte size of the XDR to complete"
                 }
      end
    end

    test "with valid data" do
      {status, result} = FixedOpaque.decode_xdr(<<0, 0, 1, 0, 0, 0, 0, 0>>, 4)

      assert status == :ok
      assert result == {<<0, 0, 1, 0>>, <<0, 0, 0, 0>>}
    end

    test "decode_xdr! with valid data" do
      result = FixedOpaque.decode_xdr!(<<0, 0, 1, 0, 0, 0, 0, 0>>, 4)

      assert result == {<<0, 0, 1, 0>>, <<0, 0, 0, 0>>}
    end
  end
end
