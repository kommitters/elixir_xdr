defmodule EnumTest do
  use ExUnit.Case

  alias XDR.Enum
  alias XDR.Error.Enum, as: EnumErr

  setup do
    enum = %Enum{declarations: [red: 0, blue: 1, yellow: 2]}

    {:ok, enum: enum}
  end

  describe "Encoding Enum structures" do

    test "when the declarations is not a list" do
      try do
        Enum.encode_xdr(%Enum{declarations: %{red: 0, blue: 1, yellow: 2}}, :red)
      rescue
        error ->
          assert error == %EnumErr{
                   message: "The declaration inside the Enum structure isn't a list"
                 }
      end
    end

    test "when specification name is not an atom", %{enum: enum} do
      try do
        Enum.encode_xdr(enum, "red")
      rescue
        error ->
          assert error ==
                   %EnumErr{message: "The name of the key which you try to encode isn't an atom"}
      end
    end

    test "with valid data", %{enum: enum} do
      {status, result} = Enum.encode_xdr(enum, :red)

      assert status === :ok
      assert result === <<0, 0, 0, 0>>
    end

    test "encode_xdr! with valid data", %{enum: enum} do
      result = Enum.encode_xdr!(enum, :yellow)

      assert result === <<0, 0, 0, 2>>
    end
  end

  describe "Decoding enum structures" do
    test "when is not binary value", %{enum: enum} do
      try do
        Enum.decode_xdr(5860 , enum)
      rescue
        error ->
          assert error ==
                   %EnumErr{
                     message:
                       "The value which you try to decode must be a binary value, for example: <<0, 0, 0, 2>>"
                   }
      end
    end

    test "when is binary enum doesn't contain a list" do
      try do
        Enum.decode_xdr(<<0, 0, 0, 0>>, %Enum{declarations: %{red: 0, blue: 1, yellow: 2}})
      rescue
        error -> assert error ==
          %EnumErr{
            message:
            "The declaration inside the Enum structure isn't a list"
          }
      end
    end

    test "with valid data", %{enum: enum} do
      {status, result} = Enum.decode_xdr(<<0, 0, 0, 0>>, enum)

      assert status == :ok
      assert result === {:red, ""}
    end

    test "decode_xdr! with valid data", %{enum: enum} do
      result = Enum.decode_xdr!(<<0, 0, 0, 0>>, enum)

      assert result === {:red, ""}
    end
  end
end
