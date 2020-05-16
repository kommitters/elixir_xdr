defmodule XDR.FixedArrayTest do
  use ExUnit.Case

  alias XDR.FixedArray
  alias XDR.Error.FixedArray, as: FixedArrayErr

  describe "Encoding Fixed Array" do
    test "when xdr is not list" do
      try do
        FixedArray.new(<<0, 0, 1>>, XDR.Int, 3)
        |> FixedArray.encode_xdr()
      rescue
        error ->
          assert error == %FixedArrayErr{
                   message: "the value which you try to encode must be a list"
                 }
      end
    end

    test "with invalid length" do
      try do
        FixedArray.new([0, 0, 1], XDR.Int, 2)
        |> FixedArray.encode_xdr()
      rescue
        error ->
          assert error == %FixedArrayErr{
                   message: "the length of the array and the length must be the same"
                 }
      end
    end

    test "when length is not an integer" do
      try do
        FixedArray.new([0, 0, 1], XDR.Int, "3")
        |> FixedArray.encode_xdr()
      rescue
        error ->
          assert error == %FixedArrayErr{
                   message: "the length received by parameter must be an integer"
                 }
      end
    end

    test "with valid data" do
      {status, result} =
        FixedArray.new([0, 0, 1], XDR.Int, 3)
        |> FixedArray.encode_xdr()

      assert status == :ok
      assert result == <<0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1>>
    end

    test "encode_xdr! with valid data" do
      result =
        FixedArray.new(["kommit.co", "kommitter", "kommit"], XDR.String, 3)
        |> FixedArray.encode_xdr!()

      assert result ==
               <<0, 0, 0, 9, 107, 111, 109, 109, 105, 116, 46, 99, 111, 0, 0, 0, 0, 0, 0, 9, 107,
                 111, 109, 109, 105, 116, 116, 101, 114, 0, 0, 0, 0, 0, 0, 6, 107, 111, 109, 109,
                 105, 116, 0, 0>>
    end
  end

  describe "Decoding Fixed Array" do
    test "when xdr is not binary" do
      try do
        FixedArray.decode_xdr([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], %XDR.FixedArray{
          type: XDR.Int,
          length: 3
        })
      rescue
        error ->
          assert error == %FixedArrayErr{
                   message: "the value which you try to decode must be a binary value"
                 }
      end
    end

    test "when xdr byte size is not a multiple of 4" do
      try do
        FixedArray.decode_xdr(<<0, 0, 1>>, %XDR.FixedArray{type: XDR.Int, length: 1})
      rescue
        error ->
          assert error == %FixedArrayErr{
                   message:
                     "the value which you try to decode must have a multiple of 4 byte-size"
                 }
      end
    end

    test "when length is not an integer" do
      try do
        FixedArray.decode_xdr(<<0, 0, 1, 0>>, %XDR.FixedArray{type: XDR.Int, length: "1"})
      rescue
        error ->
          assert error == %FixedArrayErr{
                   message: "the length received by parameter must be an integer"
                 }
      end
    end

    test "with valid data" do
      {status, result} =
        FixedArray.decode_xdr(<<0, 0, 1, 0>>, %XDR.FixedArray{type: XDR.Int, length: 1})

      assert status == :ok
      assert result == {[%XDR.Int{datum: 256}], ""}
    end

    test "decode_xdr! with valid data" do
      result =
        FixedArray.decode_xdr!(<<0, 0, 1, 0, 0, 1, 0, 0>>, %XDR.FixedArray{
          type: XDR.Int,
          length: 2
        })

      assert result == {[%XDR.Int{datum: 256}, %XDR.Int{datum: 65_536}], ""}
    end
  end
end
