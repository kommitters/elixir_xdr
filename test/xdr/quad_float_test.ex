defmodule XDR.QuadFloatTest do
  use ExUnit.Case

  alias XDR.QuadFloat

  describe "Encoding float to binary" do
    test "when receives a String" do
      try do
        QuadFloat.encode_xdr(:any,:any)
      rescue
        error ->
        assert error == %RuntimeError{message: "Not supported function"}
      end
    end

    test "encode_xdr!" do
      try do
        QuadFloat.encode_xdr!(:any,:any)
      rescue
        error ->
          assert error == %RuntimeError{message: "Not supported function"}
      end
    end
  end

  describe "Decoding binary to integer" do
    test "when is not binary value" do
      try do
        QuadFloat.decode_xdr(:any,:any)
      rescue
        error ->
            assert error == %RuntimeError{message: "Not supported function"}
      end
    end

    test "decode_xdr! with valid data" do
      try do
        QuadFloat.decode_xdr!(:any,:any)
      rescue
        error ->
            assert error == %RuntimeError{message: "Not supported function"}
      end
    end
  end
end
