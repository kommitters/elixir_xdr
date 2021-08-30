defmodule XDR.BoolTest do
  @moduledoc """
  Tests for the `XDR.Bool` module.
  """

  use ExUnit.Case

  alias XDR.{Bool, BoolError}

  describe "Encoding Boolean structures" do
    test "when the value is not boolean" do
      {status, reason} = Bool.new("true") |> Bool.encode_xdr()

      assert status == :error
      assert reason == :not_boolean
    end

    test "with valid data" do
      {status, result} = Bool.new(false) |> Bool.encode_xdr()

      assert status === :ok
      assert result === <<0, 0, 0, 0>>
    end

    test "encode_xdr! with valid data" do
      result = Bool.new(true) |> Bool.encode_xdr!()

      assert result === <<0, 0, 0, 1>>
    end

    test "encode_xdr! when is not boolean" do
      bool = Bool.new("true")

      assert_raise BoolError, fn -> Bool.encode_xdr!(bool) end
    end
  end

  describe "Decoding boolean structures" do
    test "when is not binary value" do
      {status, reason} = Bool.decode_xdr(5860)

      assert status == :error
      assert reason == :invalid_value
    end

    test "with valid data" do
      {status, result} = Bool.decode_xdr(<<0, 0, 0, 0>>)

      assert status == :ok
      assert result === {%XDR.Bool{declarations: [false: 0, true: 1], identifier: false}, ""}
    end

    test "decode_xdr! with valid data" do
      result = Bool.decode_xdr!(<<0, 0, 0, 1>>)

      assert result === {%XDR.Bool{declarations: [false: 0, true: 1], identifier: true}, ""}
    end

    test "decode_xdr! when is not binary value" do
      assert_raise BoolError, fn -> Bool.decode_xdr!(5860) end
    end
  end
end
