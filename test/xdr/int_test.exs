defmodule XDR.IntTest do
  use ExUnit.Case

  alias XDR.Int
  alias XDR.Error.Int, as: IntErr

  describe "Encoding integer to binary" do
    test "when is not an integer value" do
      try do
        Int.new("hello world")
        |> Int.encode_xdr()
      rescue
        error ->
          assert error == %IntErr{message: "The value which you try to encode is not an integer"}
      end
    end

    test "when exceeds the upper limit of an integer" do
      try do
        Int.new(3_147_483_647)
        |> Int.encode_xdr()
      rescue
        error ->
          assert error ==
                   %IntErr{
                     message:
                       "The integer which you try to encode exceed the upper limit of an integer, the value must be less than 2_147_483_647"
                   }
      end
    end

    test "when exceeds the lower limit of an integer" do
      try do
        Int.new(-3_147_483_647)
        |> Int.encode_xdr()
      rescue
        error ->
          assert error ==
                   %IntErr{
                     message:
                       "The integer which you try to encode exceed the lower limit of an integer, the value must be more than -2_147_483_648"
                   }
      end
    end

    test "when is a valid integer" do
      {status, result} =
        Int.new(5860)
        |> Int.encode_xdr()

      assert status == :ok
      assert result == <<0, 0, 22, 228>>
    end

    test "decode_xdr! with valid data" do
      result =
        Int.new(5860)
        |> Int.encode_xdr!()

      assert result == <<0, 0, 22, 228>>
    end
  end

  describe "Decoding binary to integer" do
    test "when is not binary value" do
      try do
        Int.new(5860)
        |> Int.decode_xdr()
      rescue
        error ->
          assert error ==
                   %IntErr{
                     message:
                       "The value which you try to decode must be a binary value, for example: <<0, 0, 0, 2>>"
                   }
      end
    end

    test "when is a valid binary" do
      {status, result} =
        Int.new(<<0, 0, 22, 228>>)
        |> Int.decode_xdr()

      assert status == :ok
      assert result == {5860, ""}
    end

    test "when is a valid binary with extra bytes" do
      {status, result} =
        Int.new(<<0, 0, 22, 228, 10>>)
        |> Int.decode_xdr()

      assert status == :ok
      assert result === {5860, <<10>>}
    end

    test "decode_xdr! with valid data" do
      result =
        Int.new(<<0, 0, 22, 228>>)
        |> Int.decode_xdr!()

      assert result === {5860, ""}
    end
  end
end
