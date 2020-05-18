defmodule XDR.HyperIntTest do
  use ExUnit.Case

  alias XDR.HyperInt
  alias XDR.Error.HyperInt, as: HyperIntErr

  describe "Encoding Hyper Integer to binary" do
    test "when is not an integer value" do
      try do
        HyperInt.new("hello world")
        |> HyperInt.encode_xdr()
      rescue
        error ->
          assert error == %HyperIntErr{
                   message: "The value which you try to encode is not an integer"
                 }
      end
    end

    test "when exceeds the upper limit of an integer" do
      try do
        HyperInt.new(9_223_372_036_854_775_808)
        |> HyperInt.encode_xdr()
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
        HyperInt.new(-9_223_372_036_854_775_809)
        |> HyperInt.encode_xdr()
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
      {status, result} =
        HyperInt.new(5860)
        |> HyperInt.encode_xdr()

      assert status == :ok
      assert result == <<0, 0, 0, 0, 0, 0, 22, 228>>
    end

    test "encode_xdr! with valid data" do
      result =
        HyperInt.new(5860)
        |> HyperInt.encode_xdr!()

      assert result == <<0, 0, 0, 0, 0, 0, 22, 228>>
    end
  end

  describe "Decoding binary to Hyper Integer" do
    test "when is not binary value" do
      try do
        HyperInt.new(5860)
        |> HyperInt.decode_xdr()
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
      assert result == {%XDR.HyperInt{datum: 5860}, ""}
    end

    test "when is a valid binary with extra bytes" do
      {status, result} = HyperInt.decode_xdr(<<0, 0, 0, 0, 0, 0, 22, 228, 10>>)

      assert status == :ok
      assert result === {%XDR.HyperInt{datum: 5860}, <<10>>}
    end

    test "decode_xdr! with valid data" do
      result = HyperInt.decode_xdr!(<<0, 0, 0, 0, 0, 0, 22, 228>>)

      assert result === {%XDR.HyperInt{datum: 5860}, ""}
    end
  end
end
