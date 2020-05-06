defmodule XDR.VariableArrayTest do
  use ExUnit.Case

  alias XDR.VariableArray
  alias XDR.Error.VariableArray, as: VariableArrayErr

  describe "Encoding Fixed Array" do
    test "when xdr is not list" do
      try do
        VariableArray.encode_xdr(<<0, 0, 1>>, type: XDR.Int, length: 3)
      rescue
        error ->
          assert error == %VariableArrayErr{
                   message: "the value which you try to encode must be a list"
                 }
      end
    end

    test "with invalid length" do
      try do
        VariableArray.encode_xdr([0, 0, 1], type: XDR.Int, length: 2)
      rescue
        error ->
          assert error == %VariableArrayErr{
                   message:
                     "The number which represents the length from decode the opaque as UInt is bigger than the defined max"
                 }
      end
    end

    test "when length is not an integer" do
      try do
        VariableArray.encode_xdr([0, 0, 1], type: XDR.Int, length: "3")
      rescue
        error ->
          assert error == %VariableArrayErr{
                   message: "the max length must be an integer value"
                 }
      end
    end

    test "when exceed the upper bound" do
      try do
        VariableArray.encode_xdr([0, 0, 1], type: XDR.Int, length: 4_294_967_296)
      rescue
        error ->
          assert error == %VariableArrayErr{
                   message: "The maximum value of the length of the variable is 4_294_967_295"
                 }
      end
    end

    test "when exceed the lower bound" do
      try do
        VariableArray.encode_xdr([0, 0, 1], type: XDR.Int, length: -1)
      rescue
        error ->
          assert error == %VariableArrayErr{
                   message: "The minimum value of the length of the variable is 0"
                 }
      end
    end

    test "with valid data" do
      {status, result} = VariableArray.encode_xdr([0, 0, 1], type: XDR.Int, length: 3)

      assert status == :ok
      assert result == <<0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1>>
    end

    test "encode_xdr! with valid data" do
      result =
        VariableArray.encode_xdr!(["kommit.co", "kommitter", "kommit"],
          type: XDR.String,
          length: 3
        )

      assert result ==
               <<0, 0, 0, 3, 0, 0, 0, 9, 107, 111, 109, 109, 105, 116, 46, 99, 111, 0, 0, 0, 0, 0,
                 0, 9, 107, 111, 109, 109, 105, 116, 116, 101, 114, 0, 0, 0, 0, 0, 0, 6, 107, 111,
                 109, 109, 105, 116, 0, 0>>
    end
  end

  describe "Decoding Fixed Array" do
    test "when xdr is not binary" do
      try do
        VariableArray.decode_xdr([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], type: XDR.Int, length: 3)
      rescue
        error ->
          assert error == %VariableArrayErr{
                   message:
                     "The value which you pass through parameters must be a binary value, for example: <<0, 0, 0, 5>>"
                 }
      end
    end

    test "when length is not an integer" do
      try do
        VariableArray.decode_xdr(<<0, 0, 1, 0>>, type: XDR.Int, length: "1")
      rescue
        error ->
          assert error == %VariableArrayErr{
                   message: "the max length must be an integer value"
                 }
      end
    end

    test "with valid data" do
      {status, result} =
        VariableArray.decode_xdr(
          <<0, 0, 0, 3, 0, 0, 0, 9, 107, 111, 109, 109, 105, 116, 46, 99, 111, 0, 0, 0, 0, 0, 0,
            9, 107, 111, 109, 109, 105, 116, 116, 101, 114, 0, 0, 0, 0, 0, 0, 6, 107, 111, 109,
            109, 105, 116, 0, 0>>,
          type: XDR.String,
          length: 1
        )

      assert status == :ok
      assert result == {["kommit.co", "kommitter", "kommit"], ""}
    end

    test "decode_xdr! with valid data" do
      result = VariableArray.decode_xdr!(<<0, 0, 0, 1, 0, 1, 0, 0>>, type: XDR.Int, length: 1)

      assert result == {[65536], ""}
    end
  end
end
