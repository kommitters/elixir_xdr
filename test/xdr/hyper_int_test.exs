defmodule XDR.HyperIntTest do
  use ExUnit.Case

  alias XDR.HyperInt
  alias XDR.Error.HyperInt, as: HyperIntErr

  describe "Encoding integer to binary" do
    test "when is not an integer value" do
      try do
        HyperInt.encode_xdr("hello world")
      rescue
        error ->
          assert error == %HyperIntErr{message: "The value which you try to encode is not an integer"}
      end
    end

    test "when exceeds the upper limit of an integer" do
      try do
        HyperInt.encode_xdr(9_223_372_036_854_775_808)
      rescue
        error ->
          assert error ==
                   %HyperIntErr{
                     message:
                     "The integer which you try to encode exceed the upper limit of an Hyper Integer, the value must be less than 9_223_372_036_854_775_807"
                   }
      end
    end

    test "when exceeds the lower limit of an integer" do
      try do
        HyperInt.encode_xdr(-9_223_372_036_854_775_809)
      rescue
        error ->
          assert error ==
                   %HyperIntErr{
                     message:
                     "The integer which you try to encode exceed the lower limit of an Hyper Integer, the value must be more than -9_223_372_036_854_775_808"
                   }
      end
    end

    test "when is a valid integer" do
      {status, result} = HyperInt.encode_xdr(5860)

      assert status == :ok
      assert result == <<0, 0, 0, 0, 0, 0, 22, 228>>
    end

    test "encode_xdr! with valid data" do
      result = HyperInt.encode_xdr!(5860)

      assert result == <<0, 0, 0, 0, 0, 0, 22, 228>>
    end
  end

  describe "Decoding binary to integer" do
    test "when is not binary value" do
      try do
        HyperInt.decode_xdr(5860)
      rescue
        error ->
          assert error ==
                   %HyperIntErr{
                     message:
                     "The value which you try to decode must be a binary value, for example: <<0, 0, 0, 0, 0, 0, 0, 5>>"
                   }
      end
    end

    test "when is a valid binary" do
      {status, result} = HyperInt.decode_xdr(<<0, 0, 0, 0, 0, 0, 22, 228>>)

      assert status == :ok
      assert result == {5860, ""}
    end

    test "when is a valid binary with extra bytes" do
      {status, result} = HyperInt.decode_xdr(<<0, 0, 0, 0, 0, 0, 22, 228, 10>>)

      assert status == :ok
      assert result === {5860, <<10>>}
    end

    test "decode_xdr! with valid data" do
      result = HyperInt.decode_xdr!(<<0, 0, 0, 0, 0, 0, 22, 228>>)

      assert result === {5860, ""}
    end
  end
end
