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

    test "when specification name is not an atom", %{keyword: keyword} do
      try do
        Enum.new(keyword, "red")
        |> Enum.encode_xdr()
      rescue
        error ->
          assert error ==
                   %EnumErr{message: "The name of the key which you try to encode isn't an atom"}
      end
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
  end

  describe "Decoding enum structures" do
    test "when is not binary value", %{keyword: keyword} do
      try do
        Enum.decode_xdr(5860, %XDR.Enum{declarations: keyword})
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
        Enum.decode_xdr(<<0, 0, 0, 0>>, %XDR.Enum{declarations: %{red: 0, blue: 1, yellow: 2}})
      rescue
        error ->
          assert error ==
                   %EnumErr{
                     message: "The declaration inside the Enum structure isn't a list"
                   }
      end
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
  end
end
