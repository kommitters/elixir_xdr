defmodule XDR.EnumTest do
  use ExUnit.Case

  alias XDR.Enum
  alias XDR.Error.Enum, as: EnumErr

  setup do
    keyword = [red: 0, blue: 1, yellow: 2]

    {:ok, keyword: keyword}
  end

  describe "Encoding Enum structures" do
    test "when the declarations is not a list" do
      {status, reason} =
        Enum.new(%{red: 0, blue: 1, yellow: 2}, :red)
        |> Enum.encode_xdr()

      assert status == :error
      assert reason == :not_list
    end

    test "when specification name is not an atom", %{keyword: keyword} do
      {status, reason} =
        Enum.new(keyword, "red")
        |> Enum.encode_xdr()

      assert status == :error
      assert reason == :not_an_atom
    end

    test "when key doesn't belong to keyword", %{keyword: keyword} do
      {status, reason} =
        Enum.new(keyword, :purple)
        |> Enum.encode_xdr()

      assert status == :error
      assert reason == :invalid_key
    end

    test "with valid data", %{keyword: keyword} do
      {status, result} =
        Enum.new(keyword, :red)
        |> Enum.encode_xdr()

      assert status === :ok
      assert result === <<0, 0, 0, 0>>
    end

    test "encode_xdr! with valid data", %{keyword: keyword} do
      result =
        Enum.new(keyword, :yellow)
        |> Enum.encode_xdr!()

      assert result === <<0, 0, 0, 2>>
    end

    test "encode_xdr! with invalid data", %{keyword: keyword} do
      enum = Enum.new(keyword, :purple)

      assert_raise EnumErr, fn -> Enum.encode_xdr!(enum) end
    end
  end

  describe "Decoding enum structures" do
    test "when is not binary value", %{keyword: keyword} do
      {status, reason} = Enum.decode_xdr(5860, %XDR.Enum{declarations: keyword})

      assert status == :error
      assert reason == :not_binary
    end

    test "when enum doesn't contain a list" do
      {status, reason} =
        Enum.decode_xdr(<<0, 0, 0, 0>>, %XDR.Enum{declarations: %{red: 0, blue: 1, yellow: 2}})

      assert status == :error
      assert reason == :not_list
    end

    test "with invalid key", %{keyword: keyword} do
      {status, reason} = Enum.decode_xdr(<<0, 0, 0, 3>>, %XDR.Enum{declarations: keyword})
      assert status == :error
      assert reason == :invalid_key
    end

    test "with valid data", %{keyword: keyword} do
      {status, result} = Enum.decode_xdr(<<0, 0, 0, 0>>, %XDR.Enum{declarations: keyword})

      assert status == :ok

      assert result ===
               {%XDR.Enum{declarations: [red: 0, blue: 1, yellow: 2], identifier: :red}, ""}
    end

    test "decode_xdr! with valid data", %{keyword: keyword} do
      result = Enum.decode_xdr!(<<0, 0, 0, 0>>, %XDR.Enum{declarations: keyword})

      assert result ===
               {%XDR.Enum{declarations: [red: 0, blue: 1, yellow: 2], identifier: :red}, ""}
    end

    test "decode_xdr! with invalid key", %{keyword: keyword} do
      enum = %XDR.Enum{declarations: keyword}

      assert_raise EnumErr, fn -> Enum.decode_xdr!(<<0, 0, 0, 3>>, enum) end
    end
  end
end
