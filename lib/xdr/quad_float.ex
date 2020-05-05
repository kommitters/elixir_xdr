defmodule XDR.QuadFloat do
  @moduledoc """
  This module is in charge of process the Single-Precision Floating-Point types based on the RFC4056 XDR Standard
  """

  @behaviour XDR.Declaration

  @impl XDR.Declaration
  @doc """
  not supported
  """
  @spec encode_xdr(any, any) ::any
  def encode_xdr(_, _), do: raise "Not supported function"

  @impl XDR.Declaration
  @doc """
  not supported
  """
  @spec encode_xdr!(any, any) :: any
  def encode_xdr!(_, _), do: raise "Not supported function"

  @impl XDR.Declaration
  @doc """
  not supported
  """
  @spec decode_xdr(any, any) :: any
  def decode_xdr(_, _), do: raise "Not supported function"

  @impl XDR.Declaration
  @doc """
  not supported
  """
  @spec decode_xdr!(any, any) :: any
  def decode_xdr!(_, _), do: raise "Not supported function"
end
