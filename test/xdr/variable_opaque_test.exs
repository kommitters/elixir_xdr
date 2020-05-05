defmodule XDR.VariableOpaqueTest do
  use ExUnit.Case

  alias XDR.VariableOpaque
  alias XDR.Error.VariableOpaque, as: VariableOpaqueErr

  describe "Encoding Variable Opaque" do
    test "when xdr is not binary" do
      try do
        VariableOpaque.encode_xdr([0, 0, 1], 2)
      rescue
        error ->
          assert error == %VariableOpaqueErr{
                   message:
                     "The value which you pass through parameters must be a binary value, for example: <<0, 0, 0, 5>>"
                 }
      end
    end

    test "with invalid length" do
      try do
        VariableOpaque.encode_xdr(<<0, 0, 1>>, 2)
      rescue
        error ->
          assert error == %VariableOpaqueErr{
                   message:
                     "The max length that is passed through parameters must be biger to the byte size of the XDR"
                 }
      end
    end

    test "when length is not an integer" do
      try do
        VariableOpaque.encode_xdr(<<0, 0, 1>>, "hi")
      rescue
        error ->
          assert error == %VariableOpaqueErr{
                   message: "The value which you pass through parameters is not an integer"
                 }
      end
    end

    test "when exceed lower bound" do
      try do
        VariableOpaque.encode_xdr(<<0, 0, 1>>, -1)
      rescue
        error ->
          assert error == %VariableOpaqueErr{
                   message: "The minimum value of the length of the variable is 0"
                 }
      end
    end

    test "when exceed upper bound" do
      try do
        VariableOpaque.encode_xdr(<<0, 0, 1>>, 4_294_967_296)
      rescue
        error ->
          assert error == %VariableOpaqueErr{
                   message: "The maximum value of the length of the variable is 4_294_967_295"
                 }
      end
    end

    test "with valid data" do
      {status, result} = VariableOpaque.encode_xdr(<<0, 0, 1>>)

      assert status == :ok
      assert result == <<0, 0, 0, 3, 0, 0, 1, 0>>
    end

    test "encode_xdr! with valid data" do
      result = VariableOpaque.encode_xdr!(<<0, 0, 1>>)

      assert result == <<0, 0, 0, 3, 0, 0, 1, 0>>
    end
  end

  describe "Decoding Variable Opaque" do
    test "when xdr is not binary" do
      try do
        VariableOpaque.decode_xdr([0, 0, 1], 2)
      rescue
        error ->
          assert error == %VariableOpaqueErr{
                   message:
                     "The value which you pass through parameters must be a binary value, for example: <<0, 0, 0, 5>>"
                 }
      end
    end

    test "when length is not an integer" do
      try do
        VariableOpaque.encode_xdr(<<0, 0, 1, 0>>, "2")
      rescue
        error ->
          assert error == %VariableOpaqueErr{
                   message: "The value which you pass through parameters is not an integer"
                 }
      end
    end

    test "when exceed lower bound" do
      try do
        VariableOpaque.decode_xdr(<<0, 0, 1>>, -1)
      rescue
        error ->
          assert error == %VariableOpaqueErr{
                   message: "The minimum value of the length of the variable is 0"
                 }
      end
    end

    test "when exceed upper bound" do
      try do
        VariableOpaque.decode_xdr(<<0, 0, 1>>, 4_294_967_296)
      rescue
        error ->
          assert error == %VariableOpaqueErr{
                   message: "The maximum value of the length of the variable is 4_294_967_295"
                 }
      end
    end

    test "when the length is bigger than the defined max" do
      try do
        VariableOpaque.decode_xdr(<<0, 0, 0, 6>>, 1)
      rescue
        error ->
          assert error == %VariableOpaqueErr{
                   message:
                     "The number wich represents the length from decode the opaque as UInt is bigger than the defined max (max by default is 4_294_967_295)"
                 }
      end
    end

    test "when the length is bigger than the rest binaries" do
      try do
        VariableOpaque.decode_xdr(<<0, 0, 0, 6, 0, 0, 0, 0>>)
      rescue
        error ->
          assert error == %VariableOpaqueErr{
                   message:
                     "The XDR has an invalid length, it must be less than byte-size of the rest"
                 }
      end
    end

    test "with valid data" do
      {status, result} = VariableOpaque.decode_xdr(<<0, 0, 0, 2, 0, 1, 0, 0>>)

      assert status == :ok
      assert result == {<<0, 1>>, <<>>}
    end

    test "decode_xdr! with valid data" do
      result = VariableOpaque.decode_xdr!(<<0, 0, 0, 2, 0, 1, 0, 0>>)

      assert result == {<<0, 1>>, <<>>}
    end
  end
end
