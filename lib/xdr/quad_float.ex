defmodule XDR.QuadFloat do
  @moduledoc """
  This module is not supported by the actual byte size
  """

  @behaviour XDR.Declaration

  @impl XDR.Declaration
  @doc """
  not supported
  """
  @spec encode_xdr(any, any) :: any
  def encode_xdr(_, _), do: raise("Not supported function")

  @impl XDR.Declaration
  @doc """
  not supported
  """
  @spec encode_xdr!(any, any) :: any
  def encode_xdr!(_, _), do: raise("Not supported function")

  @impl XDR.Declaration
  @doc """
  not supported
  """
  @spec decode_xdr(any, any) :: any
  def decode_xdr(_, _), do: raise("Not supported function")

  @impl XDR.Declaration
  @doc """
  not supported
  """
  @spec decode_xdr!(any, any) :: any
  def decode_xdr!(_, _), do: raise("Not supported function")
end
