defmodule XDR.QuadFloatTest do
  use ExUnit.Case

  alias XDR.QuadFloat

  test "encode_xdr" do
    try do
      QuadFloat.encode_xdr(:any)
    rescue
      error ->
        assert error == %RuntimeError{message: "Not supported function"}
    end
  end

  test "encode_xdr!" do
    try do
      QuadFloat.encode_xdr!(:any)
    rescue
      error ->
        assert error == %RuntimeError{message: "Not supported function"}
    end
  end

  test "decode_xdr" do
    try do
      QuadFloat.decode_xdr(:any)
    rescue
      error ->
        assert error == %RuntimeError{message: "Not supported function"}
    end
  end

  test "decode_xdr!" do
    try do
      QuadFloat.decode_xdr!(:any)
    rescue
      error ->
        assert error == %RuntimeError{message: "Not supported function"}
    end
  end
end
