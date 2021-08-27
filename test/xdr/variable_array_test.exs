defmodule XDR.VariableArrayTest do
  @moduledoc """
  Tests for the `XDR.VariableArray` module.
  """

  use ExUnit.Case

  alias XDR.VariableArray
  alias XDR.Error.VariableArray, as: VariableArrayError

  describe "Encoding Fixed Array" do
    test "when xdr is not list" do
      {status, reason} =
        VariableArray.new(<<0, 0, 1>>, XDR.Int, 3)
        |> VariableArray.encode_xdr()

      assert status == :error
      assert reason == :not_list
    end

    test "with invalid length" do
      {status, reason} =
        VariableArray.new([0, 0, 1], XDR.Int, 2)
        |> VariableArray.encode_xdr()

      assert status == :error
      assert reason == :length_over_max
    end

    test "when used default length" do
      {status, reason} =
        VariableArray.new([0, 0, 1], XDR.Int)
        |> VariableArray.encode_xdr()

      assert status == :ok
      assert reason == <<0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1>>
    end

    test "when length is not an integer" do
      {status, reason} =
        VariableArray.new([0, 0, 1], XDR.Int, "2")
        |> VariableArray.encode_xdr()

      assert status == :error
      assert reason == :not_number
    end

    test "when exceed the upper bound" do
      {status, reason} =
        VariableArray.new([0, 0, 1], XDR.Int, 4_294_967_296)
        |> VariableArray.encode_xdr()

      assert status == :error
      assert reason == :exceed_upper_bound
    end

    test "when exceed the lower bound" do
      {status, reason} =
        VariableArray.new([0, 0, 1], XDR.Int, -1)
        |> VariableArray.encode_xdr()

      assert status == :error
      assert reason == :exceed_lower_bound
    end

    test "with valid data" do
      {status, result} =
        VariableArray.new([0, 0, 1], XDR.Int, 3)
        |> VariableArray.encode_xdr()

      assert status == :ok
      assert result == <<0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1>>
    end

    test "with other XDR types as elements" do
      elements = [
        XDR.Enum.new([foo: 0, bar: 1], :foo),
        XDR.Enum.new([foo: 0, bar: 2], :bar)
      ]

      {status, result} =
        elements
        |> VariableArray.new(XDR.Enum, 5)
        |> VariableArray.encode_xdr()

      assert status == :ok
      assert result == <<0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 2>>
    end

    test "encode_xdr! with valid data" do
      result =
        VariableArray.new(["kommit.co", "kommitter", "kommit"], XDR.String, 3)
        |> VariableArray.encode_xdr!()

      assert result ==
               <<0, 0, 0, 3, 0, 0, 0, 9, 107, 111, 109, 109, 105, 116, 46, 99, 111, 0, 0, 0, 0, 0,
                 0, 9, 107, 111, 109, 109, 105, 116, 116, 101, 114, 0, 0, 0, 0, 0, 0, 6, 107, 111,
                 109, 109, 105, 116, 0, 0>>
    end

    test "encode_xdr! when xdr is not list" do
      variable_array = VariableArray.new(<<0, 0, 1>>, XDR.Int, 3)

      assert_raise VariableArrayError, fn -> VariableArray.encode_xdr!(variable_array) end
    end
  end

  describe "Decoding Fixed Array" do
    test "when xdr is not binary" do
      {status, reason} =
        VariableArray.decode_xdr([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], %XDR.VariableArray{
          type: XDR.Int,
          max_length: 3
        })

      assert status == :error
      assert reason == :not_binary
    end

    test "when length is not an integer" do
      {status, reason} =
        VariableArray.decode_xdr(<<0, 0, 1, 0>>, %XDR.VariableArray{
          type: XDR.Int,
          max_length: "3"
        })

      assert status == :error
      assert reason == :not_number
    end

    test "when exceeds the lower bound" do
      {status, reason} =
        VariableArray.decode_xdr(<<0, 0, 1, 0>>, %XDR.VariableArray{
          type: XDR.Int,
          max_length: -1
        })

      assert status == :error
      assert reason == :exceed_lower_bound
    end

    test "when exceeds the upper bound" do
      {status, reason} =
        VariableArray.decode_xdr(<<0, 0, 1, 0>>, %XDR.VariableArray{
          type: XDR.Int,
          max_length: 4_294_967_296
        })

      assert status == :error
      assert reason == :exceed_upper_bound
    end

    test "with invalid binary" do
      {status, reason} =
        VariableArray.decode_xdr(
          <<0, 0, 0, 15, 0, 0, 0, 9, 107, 111, 109, 109, 105, 116, 46, 99, 111, 0, 0, 0, 0, 0, 0,
            9, 107, 111, 109, 109, 105, 116, 116, 101, 114, 0, 0, 0, 0, 0, 0, 6, 107, 111, 109,
            109, 105, 116, 0, 0>>,
          %XDR.VariableArray{
            type: XDR.Int,
            max_length: 15
          }
        )

      assert status == :error
      assert reason == :invalid_binary
    end

    test "when binary length exceeds the max_length" do
      bytes =
        <<0, 0, 0, 3, 0, 0, 0, 9, 107, 111, 109, 109, 105, 116, 46, 99, 111, 0, 0, 0, 0, 0, 0, 9,
          107, 111, 109, 109, 105, 116, 116, 101, 114, 0, 0, 0, 0, 0, 0, 6, 107, 111, 109, 109,
          105, 116, 0, 0>>

      {status, reason} =
        VariableArray.decode_xdr(bytes, %XDR.VariableArray{type: XDR.Int, max_length: 1})

      assert status == :error
      assert reason == :invalid_length
    end

    test "with valid data" do
      bytes =
        <<0, 0, 0, 3, 0, 0, 0, 9, 107, 111, 109, 109, 105, 116, 46, 99, 111, 0, 0, 0, 0, 0, 0, 9,
          107, 111, 109, 109, 105, 116, 116, 101, 114, 0, 0, 0, 0, 0, 0, 6, 107, 111, 109, 109,
          105, 116, 0, 0>>

      {status, result} =
        VariableArray.decode_xdr(bytes, %XDR.VariableArray{type: XDR.String, max_length: 3})

      assert status == :ok

      assert result ==
               {[
                  %XDR.String{max_length: 4_294_967_295, string: "kommit.co"},
                  %XDR.String{max_length: 4_294_967_295, string: "kommitter"},
                  %XDR.String{max_length: 4_294_967_295, string: "kommit"}
                ], ""}
    end

    test "decode_xdr! with valid data" do
      result =
        VariableArray.decode_xdr!(<<0, 0, 0, 1, 0, 1, 0, 0>>, %XDR.VariableArray{
          type: XDR.Int,
          max_length: 1
        })

      assert result == {[%XDR.Int{datum: 65_536}], ""}
    end

    test "decode_xdr! when length is not an integer" do
      variable_array = %XDR.VariableArray{
        type: XDR.Int,
        max_length: "3"
      }

      assert_raise VariableArrayError, fn ->
        VariableArray.decode_xdr!(<<0, 0, 1, 0>>, variable_array)
      end
    end
  end
end
