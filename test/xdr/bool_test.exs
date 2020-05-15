defmodule XDR.BoolTest do
  use ExUnit.Case

  alias XDR.Bool
  alias XDR.Error.Bool, as: BoolErr

  describe "Encoding Boolean structures" do
    test "when the value is not boolean" do
      try do
        Bool.new("true")
        |> Bool.encode_xdr()
      rescue
        error ->
          assert error == %BoolErr{
                   message: "The value which you try to encode is not a boolean"
                 }
      end
    end

    test "with valid data" do
      {status, result} =
        Bool.new(false)
        |> Bool.encode_xdr()

      assert status === :ok
      assert result === <<0, 0, 0, 0>>
    end

    test "encode_xdr! with valid data" do
      result =
        Bool.new(true)
        |> Bool.encode_xdr!()

      assert result === <<0, 0, 0, 1>>
    end
  end

  describe "Decoding boolean structures" do
    test "when is not binary value" do
      try do
        Bool.decode_xdr(5860)
      rescue
        error ->
          assert error ==
                   %BoolErr{
                     message:
                       "The value which you try to decode must be <<0, 0, 0, 0>> or <<0, 0, 0, 1>>"
                   }
      end
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
  end
end
