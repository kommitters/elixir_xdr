defmodule XDR.VoidTest do
  @moduledoc """
  Tests for the `XDR.Void` module.
  """

  use ExUnit.Case

  alias XDR.{Void, VoidError}

  describe "Encoding void to binary" do
    test "when not receive a void struct" do
      {status, reason} = Void.encode_xdr("hello world")

      assert status == :error
      assert reason == :not_void
    end

    test "when receives a String" do
      {status, reason} = %Void{void: "hello world"} |> Void.encode_xdr()

      assert status == :error
      assert reason == :not_void
    end

    test "with valid data" do
      {status, reason} = Void.new(nil) |> Void.encode_xdr()

      assert status == :ok
      assert reason == <<>>
    end

    test "encode_xdr! with valid data" do
      reason = Void.new(nil) |> Void.encode_xdr!()

      assert reason == <<>>
    end

    test "encode_xdr! with invalid data" do
      assert_raise VoidError, fn -> Void.encode_xdr!(nil) end
    end
  end

  describe "Decoding binary to void" do
    test "when is not binary value" do
      {status, reason} = Void.decode_xdr(5860, Void)

      assert status == :error
      assert reason == :not_binary
    end

    test "with binary rest" do
      {status, reason} = Void.decode_xdr(<<116, 101, 115, 116>>, Void)

      assert status == :ok
      assert reason == {nil, <<116, 101, 115, 116>>}
    end

    test "when is a valid binary" do
      {status, reason} = Void.decode_xdr(<<>>, Void)

      assert status == :ok
      assert reason == {nil, ""}
    end

    test "decode_xdr! with valid data" do
      reason = Void.decode_xdr!(<<>>, Void)

      assert reason === {nil, ""}
    end

    test "decode_xdr! with rest" do
      reason = Void.decode_xdr!(<<116, 101, 115, 116>>, Void)

      assert reason === {nil, <<116, 101, 115, 116>>}
    end

    test "decode_xdr! with invalid data" do
      assert_raise VoidError, fn -> Void.decode_xdr!(12_345, XDR.Void) end
    end

    test "decode_xdr! with one parameter" do
      assert_raise VoidError, fn -> Void.decode_xdr!(nil) end
    end
  end
end
