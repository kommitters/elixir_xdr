defmodule XDR.QuadFloatTest do
  use ExUnit.Case

  alias XDR.QuadFloat

  test "encode_xdr" do
    {status, reason} = QuadFloat.encode_xdr(:any)
    assert status == :error
    assert reason == :not_supported
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
    {status, reason} = QuadFloat.decode_xdr(:any, :any)
    assert status == :error
    assert reason == :not_supported
  end

  test "decode_xdr!" do
    try do
      QuadFloat.decode_xdr!(:any, :any)
    rescue
      error ->
        assert error == %RuntimeError{message: "Not supported function"}
    end
  end
end
