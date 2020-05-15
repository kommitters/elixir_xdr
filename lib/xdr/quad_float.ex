defmodule XDR.QuadFloat do
  @behaviour XDR.Declaration
  @moduledoc """
  This module is not supported by the actual byte size
  """

  @impl XDR.Declaration
  @doc """
  not supported
  """
  @spec encode_xdr(any) :: any
  def encode_xdr(_), do: raise("Not supported function")

  @impl XDR.Declaration
  @doc """
  not supported
  """
  @spec encode_xdr!(any) :: any
  def encode_xdr!(_), do: raise("Not supported function")

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
