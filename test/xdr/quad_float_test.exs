defmodule XDR.QuadFloatTest do
  @moduledoc """
  Tests for the `XDR.QuadFloat` module.
  """

  use ExUnit.Case

  alias XDR.QuadFloat

  test "encode_xdr" do
    {status, reason} = QuadFloat.encode_xdr(:any)
    assert status == :error
    assert reason == :not_supported
  end

  test "encode_xdr!" do
    assert_raise RuntimeError, fn -> QuadFloat.encode_xdr!(:any) end
  end

  test "decode_xdr" do
    {status, reason} = QuadFloat.decode_xdr(:any, :any)
    assert status == :error
    assert reason == :not_supported
  end

  test "decode_xdr!" do
    assert_raise RuntimeError, fn -> QuadFloat.decode_xdr!(:any, :any) end
  end
end
