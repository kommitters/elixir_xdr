defmodule XDR.EnumTest do
  use ExUnit.Case

  alias XDR.Enum
  alias XDR.Error.Enum, as: EnumErr

  setup do
    enum = [red: 0, blue: 1, yellow: 2]

    {:ok, enum: enum}
  end

  describe "Encoding Enum structures" do
    test "when the declarations is not a list" do
      try do
        Enum.new(%{red: 0, blue: 1, yellow: 2}, :red)
        |> Enum.encode_xdr()
      rescue
        error ->
          assert error == %EnumErr{
                   message: "The declaration inside the Enum structure isn't a list"
                 }
      end
    end

    test "when specification name is not an atom", %{enum: enum} do
      try do
        Enum.new(enum, "red")
        |> Enum.encode_xdr()
      rescue
        error ->
          assert error ==
                   %EnumErr{message: "The name of the key which you try to encode isn't an atom"}
      end
    end

    test "with valid data", %{enum: enum} do
      {status, result} =
        Enum.new(enum, :red)
        |> Enum.encode_xdr()

      assert status === :ok
      assert result === <<0, 0, 0, 0>>
    end

    test "encode_xdr! with valid data", %{enum: enum} do
      result =
        Enum.new(enum, :yellow)
        |> Enum.encode_xdr!()

      assert result === <<0, 0, 0, 2>>
    end
  end

  describe "Decoding enum structures" do
    test "when is not binary value", %{enum: enum} do
      try do
        Enum.new(enum, 5860)
        |> Enum.decode_xdr()
      rescue
        error ->
          assert error ==
                   %EnumErr{
                     message:
                       "The value which you try to decode must be a binary value, for example: <<0, 0, 0, 2>>"
                   }
      end
    end

    test "when enum doesn't contain a list" do
      try do
        Enum.new(%{red: 0, blue: 1, yellow: 2}, <<0, 0, 0, 0>>)
        |> Enum.decode_xdr()
      rescue
        error ->
          assert error ==
                   %EnumErr{
                     message: "The declaration inside the Enum structure isn't a list"
                   }
      end
    end

    test "with valid data", %{enum: enum} do
      {status, result} =
        Enum.new(enum, <<0, 0, 0, 0>>)
        |> Enum.decode_xdr()

      assert status == :ok
      assert result === {:red, ""}
    end

    test "decode_xdr! with valid data", %{enum: enum} do
      result =
        Enum.new(enum, <<0, 0, 0, 0>>)
        |> Enum.decode_xdr!()

      assert result === {:red, ""}
    end
  end
end
