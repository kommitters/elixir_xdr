defmodule XDR.FixedOpaqueTest do
  @moduledoc """
  Tests for the `XDR.FixedOpaque` module.
  """

  use ExUnit.Case

  alias XDR.FixedOpaque
  alias XDR.Error.FixedOpaque, as: FixedOpaqueError

  describe "Encoding Fixed Opaque" do
    test "when xdr is not binary" do
      {status, reason} =
        FixedOpaque.new([0, 0, 1], 2)
        |> FixedOpaque.encode_xdr()

      assert status == :error
      assert reason == :not_binary
    end

    test "with invalid length" do
      {status, reason} =
        FixedOpaque.new(<<0, 0, 1>>, 2)
        |> FixedOpaque.encode_xdr()

      assert status == :error
      assert reason == :invalid_length
    end

    test "when length is not an integer" do
      {status, reason} =
        FixedOpaque.new(<<0, 0, 1>>, "hi")
        |> FixedOpaque.encode_xdr()

      assert status == :error
      assert reason == :not_number
    end

    test "with valid data" do
      {status, result} =
        FixedOpaque.new(<<0, 0, 1>>, 3)
        |> FixedOpaque.encode_xdr()

      assert status == :ok
      assert result == <<0, 0, 1, 0>>
    end

    test "encode_xdr! with valid data" do
      result =
        FixedOpaque.new(<<0, 0, 1>>, 3)
        |> FixedOpaque.encode_xdr!()

      assert result == <<0, 0, 1, 0>>
    end

    test "encode_xdr! when length is not an integer" do
      fixed_opaque = FixedOpaque.new(<<0, 0, 1>>, "hi")

      assert_raise FixedOpaqueError, fn -> FixedOpaque.encode_xdr!(fixed_opaque) end
    end
  end

  describe "Decoding Fixed Opaque" do
    test "when xdr is not binary" do
      {status, reason} = FixedOpaque.decode_xdr([0, 0, 1], %XDR.FixedOpaque{length: 2})
      assert status == :error
      assert reason == :not_binary
    end

    test "when xdr byte size is not a multiple of 4" do
      {status, reason} = FixedOpaque.decode_xdr(<<0, 0, 1>>, %XDR.FixedOpaque{length: 2})
      assert status == :error
      assert reason == :not_valid_binary
    end

    test "when length is not an integer" do
      {status, reason} = FixedOpaque.decode_xdr(<<0, 0, 1, 0>>, %XDR.FixedOpaque{length: "2"})
      assert status == :error
      assert reason == :not_number
    end

    test "when the length is bigger than the XDR byte-size" do
      {status, reason} = FixedOpaque.decode_xdr(<<0, 0, 1, 0>>, %XDR.FixedOpaque{length: 5})
      assert status == :error
      assert reason == :exceed_length
    end

    test "with valid data" do
      {status, result} =
        FixedOpaque.decode_xdr(<<0, 0, 1, 0, 0, 0, 0, 0>>, %XDR.FixedOpaque{length: 4})

      assert status == :ok
      assert result == {%XDR.FixedOpaque{length: 4, opaque: <<0, 0, 1, 0>>}, <<0, 0, 0, 0>>}
    end

    test "decode_xdr! with valid data" do
      result = FixedOpaque.decode_xdr!(<<0, 0, 1, 0, 0, 0, 0, 0>>, %XDR.FixedOpaque{length: 4})

      assert result == {%XDR.FixedOpaque{length: 4, opaque: <<0, 0, 1, 0>>}, <<0, 0, 0, 0>>}
    end

    test "decode_xdr! when length is not an integer" do
      fixed_opaque = %XDR.FixedOpaque{length: "2"}

      assert_raise FixedOpaqueError, fn ->
        FixedOpaque.decode_xdr!(<<0, 0, 1, 0>>, fixed_opaque)
      end
    end
  end
end
