defmodule XDR.HyperUIntTest do
  use ExUnit.Case

  alias XDR.HyperUInt
  alias XDR.Error.HyperUInt, as: HyperUIntErr

  describe "Encoding Hyper Unsigned Integer to binary" do
    test "when is not an integer value" do
      try do
        HyperUInt.new("hello world")
        |> HyperUInt.encode_xdr()
      rescue
        error ->
          assert error == %HyperUIntErr{
                   message: "The value which you try to encode is not an integer"
                 }
      end
    end

    test "when exceeds the upper limit of an integer" do
      try do
        HyperUInt.new(18_446_744_073_709_551_616)
        |> HyperUInt.encode_xdr()
      rescue
        error ->
          assert error ==
                   %HyperUIntErr{
                     message:
                       "The integer which you try to encode exceed the upper limit of an Hyper Unsigned Integer, the value must be less than 18_446_744_073_709_551_615"
                   }
      end
    end

    test "when exceeds the lower limit of an integer" do
      try do
        HyperUInt.new(-809)
        |> HyperUInt.encode_xdr()
      rescue
        error ->
          assert error ==
                   %HyperUIntErr{
                     message:
                       "The integer which you try to encode exceed the lower limit of an Hyper Unsigned Integer, the value must be more than 0"
                   }
      end
    end

    test "when is a valid integer" do
      {status, result} =
        HyperUInt.new(5860)
        |> HyperUInt.encode_xdr()

      assert status == :ok
      assert result == <<0, 0, 0, 0, 0, 0, 22, 228>>
    end

    test "encode_xdr! with valid data" do
      result =
        HyperUInt.new(5860)
        |> HyperUInt.encode_xdr!()

      assert result == <<0, 0, 0, 0, 0, 0, 22, 228>>
    end
  end

  describe "Decoding binary to Hyper Unsigned Integer" do
    test "when is not binary value" do
      try do
        HyperUInt.decode_xdr(5860)
      rescue
        error ->
          assert error ==
                   %HyperUIntErr{
                     message:
                       "The value which you try to decode must be a binary value, for example: <<0, 0, 0, 0, 0, 0, 0, 5>>"
                   }
      end
    end

    test "when is a valid binary" do
      {status, result} = HyperUInt.decode_xdr(<<0, 0, 0, 0, 0, 0, 22, 228>>)

      assert status == :ok
      assert result == {%XDR.HyperUInt{datum: 5860}, ""}
    end

    test "when is a valid binary with extra bytes" do
      {status, result} = HyperUInt.decode_xdr(<<0, 0, 0, 0, 0, 0, 22, 228, 10>>)

      assert status == :ok
      assert result === {%XDR.HyperUInt{datum: 5860}, <<10>>}
    end

    test "decode_xdr! with valid data" do
      result = HyperUInt.decode_xdr!(<<0, 0, 0, 0, 0, 0, 22, 228>>)

      assert result === {%XDR.HyperUInt{datum: 5860}, ""}
    end
  end
end
