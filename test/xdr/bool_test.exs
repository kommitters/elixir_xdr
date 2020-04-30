defmodule XDR.BoolTest do
  use ExUnit.Case

  alias XDR.Bool
  alias XDR.Error.Bool, as: BoolErr
  alias XDR.Error.Enum, as: EnumErr

  describe "Encoding Boolean structures" do
    test "when the value is not boolean" do
      try do
        Bool.encode_xdr("true")
      rescue
        error ->
          assert error == %BoolErr{
                   message: "The value which you try to encode is not a boolean"
                 }
      end
    end

    test "with valid data" do
      {status, result} = Bool.encode_xdr(false)

      assert status === :ok
      assert result === <<0, 0, 0, 0>>
    end

    test "encode_xdr! with valid data" do
      result = Bool.encode_xdr!(true)

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
                   %EnumErr{
                     message:
                       "The value which you try to decode must be a binary value, for example: <<0, 0, 0, 2>>"
                   }
      end
    end

    test "with valid data" do
      {status, result} = Bool.decode_xdr(<<0, 0, 0, 0>>)

      assert status == :ok
      assert result === {false, ""}
    end

    test "decode_xdr! with valid data" do
      result = Bool.decode_xdr!(<<0, 0, 0, 1>>)

      assert result === {true, ""}
    end
  end
end
