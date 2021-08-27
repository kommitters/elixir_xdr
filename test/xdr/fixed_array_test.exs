defmodule XDR.FixedArrayTest do
  @moduledoc """
  Tests for the `XDR.FixedArray` module.
  """

  use ExUnit.Case

  alias XDR.{FixedArray, IntError, FixedArrayError}

  describe "Encoding Fixed Array" do
    test "with invalid type" do
      {status, reason} =
        FixedArray.new([0, 0, 1], "XDR.Int", 3)
        |> FixedArray.encode_xdr()

      assert status == :error
      assert reason == :invalid_type
    end

    test "when xdr is not list" do
      {status, reason} =
        FixedArray.new(<<0, 0, 1>>, XDR.Int, 3)
        |> FixedArray.encode_xdr()

      assert status == :error
      assert reason == :not_list
    end

    test "with invalid length" do
      {status, reason} =
        FixedArray.new([0, 0, 1], XDR.Int, 2)
        |> FixedArray.encode_xdr()

      assert status == :error
      assert reason == :invalid_length
    end

    test "when length is not an integer" do
      {status, reason} =
        FixedArray.new([0, 0, 1], XDR.Int, "3")
        |> FixedArray.encode_xdr()

      assert status == :error
      assert reason == :not_number
    end

    test "with other XDR types as elements but different type" do
      elements = [
        XDR.Enum.new([foo: 0, bar: 1], :foo),
        XDR.Enum.new([foo: 0, bar: 2], :bar)
      ]

      fixed_array = FixedArray.new(elements, XDR.Int, 2)

      assert_raise IntError, fn -> FixedArray.encode_xdr(fixed_array) end
    end

    test "with valid data" do
      {status, result} =
        FixedArray.new([0, 0, 1], XDR.Int, 3)
        |> FixedArray.encode_xdr()

      assert status == :ok
      assert result == <<0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1>>
    end

    test "with other XDR types as elements" do
      elements = [
        XDR.Enum.new([foo: 0, bar: 1], :foo),
        XDR.Enum.new([foo: 0, bar: 2], :bar)
      ]

      {status, result} =
        elements
        |> FixedArray.new(XDR.Enum, 2)
        |> FixedArray.encode_xdr()

      assert status == :ok
      assert result == <<0, 0, 0, 0, 0, 0, 0, 2>>
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

    test "encode_xdr! when length is not an integer" do
      fixed_array = FixedArray.new([0, 0, 1], XDR.Int, "3")

      assert_raise FixedArrayError, fn -> FixedArray.encode_xdr!(fixed_array) end
    end
  end

  describe "Decoding Fixed Array" do
    test "with invalid type" do
      {status, result} =
        FixedArray.decode_xdr(<<0, 0, 1, 0>>, %XDR.FixedArray{type: "XDR.Int", length: 1})

      assert status == :error
      assert result == :invalid_type
    end

    test "when xdr is not binary" do
      {status, result} =
        FixedArray.decode_xdr([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], %XDR.FixedArray{
          type: XDR.Int,
          length: 3
        })

      assert status == :error
      assert result == :not_binary
    end

    test "when xdr byte size is not a multiple of 4" do
      {status, result} =
        FixedArray.decode_xdr(<<0, 0, 1>>, %XDR.FixedArray{type: XDR.Int, length: 1})

      assert status == :error
      assert result == :not_valid_binary
    end

    test "when length is not an integer" do
      {status, result} =
        FixedArray.decode_xdr(<<0, 0, 1, 0>>, %XDR.FixedArray{type: XDR.Int, length: "1"})

      assert status == :error
      assert result == :not_number
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

    test "decode_xdr! with invalid data" do
      fixed_array = %XDR.FixedArray{type: XDR.Int, length: 1}

      assert_raise FixedArrayError, fn -> FixedArray.decode_xdr!(<<0, 0, 1>>, fixed_array) end
    end
  end
end
